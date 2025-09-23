import {
  GlobeAsiaAustraliaIcon,
  TrophyIcon,
  WifiIcon,
} from "@heroicons/react/24/solid"
import { Challenge } from "@prisma/client"
import Link from "next/link"
import { useState } from "react"
import { useForm } from "react-hook-form"
import { Errors } from "./Errors"
import { LoadingButton } from "./LoadingButton"
import { Success } from "./Success"

export const JoinChallenge = ({
  challenge,
  onJoin,
}: {
  challenge: Challenge
  onJoin: (teamId: string | undefined) => void
}) => {
  const { register, handleSubmit } = useForm()
  const [errors, setErrors] = useState<string[]>([])
  const [success, setSuccess] = useState<string>("")
  const [isLoading, setIsLoading] = useState<boolean>(false)
  const [rateLimitError, setRateLimitError] = useState<string>("")

  const createTeam = async (data: any, challengeId: string) => {
    setErrors([])
    setSuccess("")
    setRateLimitError("")

    // Validate team name length
    if (data.teamName.length < 2 || data.teamName.length > 50) {
      setErrors(["Team name must be between 2 and 50 characters"])
      return
    }

    setIsLoading(true)
    
    try {
      const response = await fetch("/api/createTeam", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          name: data.teamName,
          challengeId,
        }),
      })

      const responseData = await response.json()
      
      if (response.status === 200) {
        const teamId = responseData
        onJoin(teamId)
      } else if (response.status === 429) {
        setRateLimitError("Too many attempts. Please wait before trying again.")
      } else {
        setErrors([`There was an error creating your team: ${responseData.error || 'Unknown error'}`])
      }
    } catch (error) {
      console.error("Error:", error)
      setErrors(["There was an error creating your team"])
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="py-10 bg-gray-100 grow">
      <div
        className="max-w-3xl mx-auto py-8 px-4 sm:px-6 lg:px-8 bg-white shadow md:rounded-lg"
        key={challenge.id}
      >
        <form onSubmit={handleSubmit((data) => createTeam(data, challenge.id))}>
          <div className="space-y-8 divide-y divide-gray-200">
            <div>
              <div>
                <h3 className="text-lg leading-6 font-medium text-gray-900">
                  {challenge.name}
                  {challenge.subtitle ? (
                    <span className="hidden md:inline">: </span>
                  ) : (
                    ""
                  )}
                  <span className="block md:inline text-md md:text-lg text-gray-500 md:text-gray-900">
                    {challenge?.subtitle}
                  </span>
                </h3>

                <div className="mt-4 text-sm">
                  <ul className="list-none space-y-4 pl-0">
                    <li className="flex items-center space-x-3">
                      <GlobeAsiaAustraliaIcon className="flex-shrink-0 mr-1 w-5 h-5 text-indigo-500 inline-block" />
                      <span>{'Answer questions to train your estimation skills'}</span>
                    </li>
                    <li className="flex items-center space-x-3">
                      <TrophyIcon className="flex-shrink-0 mr-1 w-5 h-5 text-indigo-500 inline-block" />
                      <span>
                        {"See how your scores compare on the "}
                        <Link
                          href={`/${challenge.id}/leaderboard`}
                        >
                          <a className="underline">leaderboard</a>
                        </Link>
                      </span>
                    </li>
                    <li className="flex items-center space-x-3">
                      <WifiIcon className="flex-shrink-0 mr-1 w-5 h-5 text-indigo-500 inline-block" />
                      <span>
                        {
                          "Estimate based on your knowledge - don't look things up online"
                        }
                      </span>
                    </li>
                  </ul>
                </div>
              </div>
              <div className="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
                <div className="sm:col-span-3">
                  <label
                    htmlFor="teamName"
                    className="block text-sm font-medium text-gray-700"
                  >
                    Team name
                  </label>
                  <div className="mt-1">
                    <input
                      type="text"
                      className="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
                      {...register("teamName")}
                      defaultValue={""}
                      autoFocus
                      placeholder="Enter a team name provided by the organizer"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div>
            {errors.length > 0 && (
              <div className="pt-5">
                <Errors errors={errors} />
              </div>
            )}
            {rateLimitError && (
              <div className="pt-5">
                <div className="text-red-600 text-sm">{rateLimitError}</div>
              </div>
            )}
            {success !== "" && (
              <div className="pt-5">
                <Success message={success} onClose={() => setSuccess("")} />
              </div>
            )}
            <div className="pt-5">
              <div className="flex justify-end">
                <LoadingButton
                  isLoading={isLoading}
                  buttonText="Join game"
                  loadingText="Joining game..."
                  submit={true}
                  onClick={() => {}}
                />
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  )
}
