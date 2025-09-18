import { TrophyIcon } from "@heroicons/react/24/solid"
import Link from "next/link"
import { useEffect, useState } from "react"
import Confetti from "react-dom-confetti"
import { ChallengeWithTeamsAndQuestions } from "../types/additional"
import { ChallengeLeaderboard } from "./ChallengeLeaderboard"
import { OpenEndedQuestions } from "./OpenEndedQuestions"

export function ChallengeComplete({
  challenge,
  teamId,
}: {
  challenge: ChallengeWithTeamsAndQuestions
  teamId: string
}) {
  const [showConfetti, setShowConfetti] = useState<boolean>(false)
  useEffect(() => {
    setShowConfetti(true)
  })

  return (
    <>
      <div className="flex flex-col items-center justify-center">
        <h3 className="text-lg text-center font-semibold mt-12">
          {" "}
          Challenge complete!
        </h3>
        <div className="mx-auto">
          <Confetti
            active={showConfetti}
            config={{
              colors: ["#4338ca", "#818cf8"],
            }}
          />
        </div>

        <OpenEndedQuestions />
      </div>

      <div className="max-h-[405px] overflow-y-auto">
        <ChallengeLeaderboard
          challengeId={challenge.id}
          teamId={teamId}
          latestQuestion={null}
        />
      </div>

      <div className="text-center">
        <Link
          href={`/leaderboard`}
          passHref
          className="mx-auto"
        >
          <a
            type="button"
            className="text-lg inline-flex mx-auto items-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            <TrophyIcon className="-ml-1 mr-2 h-5 w-5" aria-hidden="true" />
            <span>All-time leaderboard</span>
          </a>
        </Link>
      </div>
    </>
  )
}
