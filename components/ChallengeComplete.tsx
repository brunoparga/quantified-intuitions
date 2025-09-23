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
    </>
  )
}
