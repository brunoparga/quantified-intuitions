import { GetServerSideProps, NextPage } from "next"
import Link from "next/link"
import { useRouter } from "next/router"
import { useState } from "react"
import QRCode from "react-qr-code"
import { ChallengeLeaderboard } from "../components/ChallengeLeaderboard"
import { LoadingButton } from "../components/LoadingButton"
import { NavbarChallenge } from "../components/NavbarChallenge"
import { Prisma } from "../lib/prisma"
import { ChallengeWithTeamsAndQuestions } from "../types/additional"

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

const Leaderboard: NextPage<ChallengeProps> = ({ challenge }) => {
  const router = useRouter()

  const [showJoinCode, setShowJoinCode] = useState(false)

  return (
    <div className="flex flex-col min-h-screen justify-between">
      <NavbarChallenge />

      {
        challenge ?
          (
            <div className="px-4 py-6 grow mx-auto">
              <div className="py-8 mx-auto">
                <h2 className="text-3xl mb-2 font-extrabold text-gray-900">
                  {"Leaderboard"}
                </h2>
                <h3 className="text-gray-600 prose">
                  <Link href={`/${challenge.id}`}>{challenge.name}</Link>
                </h3>
                {!showJoinCode && <div className="mt-8">
                  <LoadingButton
                    onClick={() => setShowJoinCode(!showJoinCode)} buttonText={`${showJoinCode ? "Hide" : "Show"} QR code`}
                    isLoading={false}
                    loadingText=""
                  />
                </div>}
                {showJoinCode && 
                <div className="mx-auto text-center my-8">
                  <p className="prose">Join game: <Link href={`/${challenge.id}`}>{`quantifiedintuitions.org/${challenge.id}`}</Link></p>
                  <QRCode value={`https://quantifiedintuitions.org/${challenge.id}`} size={300} className="flex-grow mx-auto pt-8 aspect-square" />
                </div>}
                <ChallengeLeaderboard challengeId={challenge.id} latestQuestion={null} teamId={null} />
              </div>
            </div>
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
export default Leaderboard
