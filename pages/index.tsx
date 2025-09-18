import { Challenge } from "@prisma/client"
import { useRouter } from "next/router"
import { JoinChallenge } from "../components/JoinChallenge"
import { NavbarChallenge } from "../components/NavbarChallenge"
import { Prisma } from "../lib/prisma"

export const getStaticProps = async () => {
  const activeChallenges = await Prisma.challenge.findMany({
    where: {
      isDeleted: false,
      unlisted: false,
    },
  })

  return {
    props: {
      activeChallenges,
    },
    revalidate: 600, // Regenerate every 10 minutes
  }
}

const ChallengePage = ({
  activeChallenges,
}: {
  activeChallenges: Challenge[]
}) => {
  const router = useRouter()

  return (
    <div className="flex flex-col min-h-screen justify-between">
      <NavbarChallenge />
      <div className="py-10 bg-gray-100 grow">
        <main>
          {activeChallenges?.length == 0 && (
            <div className="max-w-3xl mx-auto py-8 px-4 sm:px-6 lg:px-8 bg-white shadow rounded-lg">
              <p>Check back soon for the next game</p>
            </div>
          )}
          {activeChallenges
            ?.filter(
              (challenge) =>
                challenge.startDate <= new Date() &&
                challenge.endDate > new Date()
            )
            .map((challenge) => (
              <JoinChallenge
                challenge={challenge}
                key={challenge.id}
                onJoin={(teamId) => router.replace(`/${challenge.id}?teamId=${teamId}`)}
              />
            ))}
        </main>
      </div>
    </div>
  )
}

export default ChallengePage
