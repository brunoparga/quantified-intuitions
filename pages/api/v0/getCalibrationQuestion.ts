import { NextApiRequest, NextApiResponse } from "next"
import { serialize } from "superjson"

import { Prisma } from "../../../lib/prisma"

interface Request extends NextApiRequest {
  query: {
    tags: string
  }
}

const getCalibrationQuestion = async (req: Request, res: NextApiResponse) => {
  const { tags } = req.query

  // No authentication required for challenge mode

  const uniqueCalibrationQuestions = await Prisma.calibrationQuestion.findMany({
    where: {
      isDeleted: false,
      challengeOnly: false,
      tags: {
        some: {
          id: {
            in: tags.split(","),
          }
        }
      },
      calibrationAnswers: {
        none: {
          userId: {
            equals: session.user.id,
          }
        },
      },
    },
    include: {
      calibrationAnswers: true
    },
  });
  if (uniqueCalibrationQuestions.length === 0) {
    return res.status(200).json(serialize({allQuestionsAnswered: true}))
  }
  const nextQuestion = uniqueCalibrationQuestions[Math.floor(Math.random() * uniqueCalibrationQuestions.length)];
  
  res.status(200).json(serialize({
    calibrationQuestion: {...nextQuestion, calibrationAnswers: undefined},
    scores: nextQuestion.calibrationAnswers.map(a => a.score),
  }))
}
export default getCalibrationQuestion
