import { NextApiRequest, NextApiResponse } from "next"
import { Prisma } from "../../../lib/prisma"
import { isCronJob } from "../../../lib/utils"

export default async function checkUpcomingGames(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (!isCronJob(req)) {
    return res.status(401).json({ message: "Unauthorized" })
  }

  if (req.method !== "GET") {
    return res.status(405).json({ error: "Method not allowed" })
  }

  const upcomingGames = await Prisma.challenge.findMany({
    where: {
      startDate: {
        gt: new Date(),
      },
      unlisted: false,
      isDeleted: false,
    },
  })

  if (upcomingGames.length === 0) {
    console.warn("Warning: no upcoming estimation game")
  }

  res.status(200).json({
    message: "Check completed",
    upcomingGamesCount: upcomingGames.length,
  })
}
