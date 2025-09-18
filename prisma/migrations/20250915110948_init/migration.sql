-- CreateTable
CREATE TABLE "Challenge" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "subtitle" TEXT,
    "startDate" DATETIME NOT NULL,
    "endDate" DATETIME NOT NULL,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "unlisted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "challengeId" TEXT NOT NULL,
    "numPlayers" INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT "Team_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "Challenge" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "CalibrationQuestion" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "content" TEXT NOT NULL,
    "answer" REAL NOT NULL,
    "prefix" TEXT NOT NULL DEFAULT '',
    "postfix" TEXT NOT NULL DEFAULT '',
    "useLogScoring" BOOLEAN NOT NULL DEFAULT false,
    "C" REAL NOT NULL DEFAULT 100,
    "source" TEXT NOT NULL DEFAULT '',
    "context" TEXT NOT NULL DEFAULT ''
);

-- CreateTable
CREATE TABLE "TeamFermiAnswer" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "teamId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "lowerBound" REAL,
    "upperBound" REAL,
    "score" REAL NOT NULL,
    "correct" BOOLEAN NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "TeamFermiAnswer_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "TeamFermiAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "CalibrationQuestion" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "AboveBelowQuestion" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "content" TEXT NOT NULL,
    "quantity" TEXT NOT NULL,
    "answerIsAbove" BOOLEAN NOT NULL,
    "preciseAnswer" TEXT NOT NULL,
    "source" TEXT NOT NULL DEFAULT ''
);

-- CreateTable
CREATE TABLE "TeamAboveBelowAnswer" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "teamId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "confidence" REAL NOT NULL,
    "score" REAL NOT NULL,
    "correct" BOOLEAN NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "TeamAboveBelowAnswer_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "TeamAboveBelowAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "AboveBelowQuestion" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_CalibrationQuestionToChallenge" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_CalibrationQuestionToChallenge_A_fkey" FOREIGN KEY ("A") REFERENCES "CalibrationQuestion" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_CalibrationQuestionToChallenge_B_fkey" FOREIGN KEY ("B") REFERENCES "Challenge" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_AboveBelowQuestionToChallenge" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_AboveBelowQuestionToChallenge_A_fkey" FOREIGN KEY ("A") REFERENCES "AboveBelowQuestion" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_AboveBelowQuestionToChallenge_B_fkey" FOREIGN KEY ("B") REFERENCES "Challenge" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "_CalibrationQuestionToChallenge_AB_unique" ON "_CalibrationQuestionToChallenge"("A", "B");

-- CreateIndex
CREATE INDEX "_CalibrationQuestionToChallenge_B_index" ON "_CalibrationQuestionToChallenge"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_AboveBelowQuestionToChallenge_AB_unique" ON "_AboveBelowQuestionToChallenge"("A", "B");

-- CreateIndex
CREATE INDEX "_AboveBelowQuestionToChallenge_B_index" ON "_AboveBelowQuestionToChallenge"("B");
