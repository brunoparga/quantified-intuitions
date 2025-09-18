import {
  AboveBelowQuestion,
  CalibrationAnswer,
  CalibrationQuestion,
  Challenge,
  Comment,
  Pastcast,
  Question,
  Team,
  TeamAboveBelowAnswer,
  TeamFermiAnswer,
} from "@prisma/client"

export type PastcastWithQuestion = Pastcast & {
  question: Question
}

export type QuestionWithComments = Question & {
  comments: Comment[]
}

export type QuestionWithCommentsAndPastcasts = Question & {
  comments: Comment[]
  pastcasts: Pastcast[]
}

export type ChallengeWithTeamsAndQuestions = Challenge & {
  teams: Team[]
  fermiQuestions: (CalibrationQuestion & {
    teamAnswers: TeamFermiAnswer[]
  })[]
  aboveBelowQuestions: (AboveBelowQuestion & {
    teamAnswers: TeamAboveBelowAnswer[]
  })[]
}

export type CalibrationOptions =
  | "QuestionDescription"
  | "VantageSearch"
  | "Scores"
  | "Leaderboard"
  | "WikiSearch"
