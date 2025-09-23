import { GetServerSideProps, NextPage } from "next"
import Link from "next/link"
import { useRouter } from "next/router"
import { useEffect, useState } from "react"
import { Challenge } from "../../components/Challenge"
import { JoinChallenge } from "../../components/JoinChallenge"
import { NavbarChallenge } from "../../components/NavbarChallenge"
import { Prisma } from "../../lib/prisma"
import { ChallengeWithTeamsAndQuestions } from "../../types/additional"

export type ChallengeProps = {
  challenge: ChallengeWithTeamsAndQuestions
}

export const getServerSideProps: GetServerSideProps<ChallengeProps | {}> = async (
  ctx
) => {
  const challengeId = ctx.query.id as string

  const challenge = await Prisma.challenge.findUnique({
    where: { id: challengeId },
    include: {
      fermiQuestions: {
        include: {
          teamAnswers: true
        }
      },
      aboveBelowQuestions: {
        include: {
          teamAnswers: true
        }
      },
      teams: true,
    },
  })
  return {
    props: {
      challenge,
    },
  }
}

const ChallengePage: NextPage<ChallengeProps> = ({ challenge }) => {
  const router = useRouter()
  const [teamId, setTeamId] = useState<string | null>(null)

  useEffect(() => {
    if (router.isReady) {
      const { teamId: queryTeamId } = router.query
      if (queryTeamId && typeof queryTeamId === 'string') {
        setTeamId(queryTeamId)
      }
    }
  }, [router.isReady, router.query])

  return (
    <div className="flex flex-col min-h-screen justify-between">
      <NavbarChallenge />

      {
        challenge ?
          (
            teamId ?
              <Challenge challenge={challenge} teamId={teamId} />
              :
              <JoinChallenge challenge={challenge} onJoin={(teamId) => {
                router.push(`/${challenge.id}?teamId=${teamId}`)
              }} />
          )
          :
          (
            <div className="py-10 bg-gray-100 grow">
              <p className="prose max-w-prose m-auto">{"That Estimation Game doesn't exist. "} 
                <Link href="/">{"See all public current and upcoming games."}</Link>
              </p>
            </div>
          )
      }

    </div>
  )
}
export default ChallengePage
