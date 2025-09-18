import { NextPage } from "next"
import Link from "next/link"
import { NavbarChallenge } from "../components/NavbarChallenge"

const Leaderboard: NextPage<{}> = () => {
  return (
    <div className="flex flex-col min-h-screen justify-between">
      <NavbarChallenge />
      <div className="px-4 py-6 grow mx-auto">
        <div className="py-8 mx-auto">
          <h3 className="text-gray-600 prose">
            <Link href={`/`}>The Estimation Game</Link>
          </h3>
        </div>
      </div>
    </div>
  )
}
export default Leaderboard
