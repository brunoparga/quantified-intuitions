import { NextApiRequest, NextApiResponse } from "next"
import { serialize } from "superjson"

import { Prisma } from "../../../lib/prisma"

interface Request extends NextApiRequest {
  query: {
    tags: string
  }
}

const getCalibrationDeckStats = async (req: Request, res: NextApiResponse) => {
  // No authentication required for challenge mode

  const tags = await Prisma.calibrationQuestionTag.findMany({
    where: {
      showInDeckSwitcher: true,
    },
    include: {
      questions: {
        where: {
          isDeleted: false,
        },
        include: {
          calibrationAnswers: {
            where: {
              userId: session.user.id,
              isDeleted: false,
            },
          },
        },
      }
    }
  })

  const results = tags.map(tag => ({
    tag: tag.id,
    totalQuestions: tag.questions.length,
    answered: tag.questions.filter(question => question.calibrationAnswers.length > 0).length,
    totalScore: tag.questions.reduce((acc, question) => {
      const score = question.calibrationAnswers?.[0]?.score || 0
      return acc + score
    }, 0)
  }))

  res.status(200).json(serialize(results))
}
export default getCalibrationDeckStats
