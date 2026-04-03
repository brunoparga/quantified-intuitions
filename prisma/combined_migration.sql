-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,
    "loadingProgress" DOUBLE PRECISION,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "Question" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "crowdForecast" DOUBLE PRECISION,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "vantageDate" TIMESTAMP(3) NOT NULL,
    "binaryResolution" BOOLEAN NOT NULL,
    "url" TEXT,
    "platform" TEXT,
    "fetched" TIMESTAMP(3),

    CONSTRAINT "Question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pastcast" (
    "userId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "binaryProbability" DOUBLE PRECISION,
    "score" DOUBLE PRECISION NOT NULL,
    "skipped" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Pastcast_pkey" PRIMARY KEY ("questionId","userId")
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pastcast" ADD CONSTRAINT "Pastcast_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pastcast" ADD CONSTRAINT "Pastcast_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question"("id") ON DELETE CASCADE ON UPDATE CASCADE;
/*
  Warnings:

  - You are about to drop the column `loadingProgress` on the `User` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "User" DROP COLUMN "loadingProgress";
-- CreateTable
CREATE TABLE "Search" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "finished" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Search_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SearchResult" (
    "id" TEXT NOT NULL,
    "position" INTEGER NOT NULL,
    "displayedLink" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "snippet" TEXT NOT NULL,
    "searchId" TEXT,

    CONSTRAINT "SearchResult_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Search" ADD CONSTRAINT "Search_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SearchResult" ADD CONSTRAINT "SearchResult_searchId_fkey" FOREIGN KEY ("searchId") REFERENCES "Search"("id") ON DELETE SET NULL ON UPDATE CASCADE;
-- CreateTable
CREATE TABLE "Comment" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "voteTotal" INTEGER NOT NULL DEFAULT 0,
    "parentCommentId" TEXT,
    "questionId" TEXT NOT NULL,
    "authorName" TEXT NOT NULL,
    "predictionValue" DOUBLE PRECISION,
    "fetched" TIMESTAMP(6) NOT NULL,
    "platform" TEXT NOT NULL,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question"("id") ON DELETE CASCADE ON UPDATE CASCADE;
-- AlterTable
ALTER TABLE "Comment" ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false;
-- AlterTable
ALTER TABLE "Pastcast" ADD COLUMN     "timeSpent" INTEGER DEFAULT 0;
-- CreateTable
CREATE TABLE "NewComment" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "parentCommentId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "binaryProbability" DOUBLE PRECISION,

    CONSTRAINT "NewComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserCommentInteraction" (
    "userId" TEXT NOT NULL,
    "newCommentId" TEXT NOT NULL,
    "upvotes" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "UserCommentInteraction_pkey" PRIMARY KEY ("userId","newCommentId")
);

-- AddForeignKey
ALTER TABLE "UserCommentInteraction" ADD CONSTRAINT "UserCommentInteraction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserCommentInteraction" ADD CONSTRAINT "UserCommentInteraction_newCommentId_fkey" FOREIGN KEY ("newCommentId") REFERENCES "NewComment"("id") ON DELETE CASCADE ON UPDATE CASCADE;
-- AlterTable
ALTER TABLE "Pastcast" ADD COLUMN     "roomId" TEXT;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "roomId" TEXT;

-- CreateTable
CREATE TABLE "Room" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "maxSecondsPerQuestion" INTEGER NOT NULL DEFAULT 600,
    "totalQuestions" INTEGER NOT NULL DEFAULT 1,
    "currentQuestionId" TEXT,
    "currentStartTime" TIMESTAMP(3),
    "isFinshed" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Room_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_PastQuestion" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_PastQuestion_AB_unique" ON "_PastQuestion"("A", "B");

-- CreateIndex
CREATE INDEX "_PastQuestion_B_index" ON "_PastQuestion"("B");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "Room"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pastcast" ADD CONSTRAINT "Pastcast_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "Room"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Room" ADD CONSTRAINT "Room_currentQuestionId_fkey" FOREIGN KEY ("currentQuestionId") REFERENCES "Question"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PastQuestion" ADD CONSTRAINT "_PastQuestion_A_fkey" FOREIGN KEY ("A") REFERENCES "Question"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PastQuestion" ADD CONSTRAINT "_PastQuestion_B_fkey" FOREIGN KEY ("B") REFERENCES "Room"("id") ON DELETE CASCADE ON UPDATE CASCADE;
/*
  Warnings:

  - You are about to drop the column `roomId` on the `User` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_roomId_fkey";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "roomId";

-- CreateTable
CREATE TABLE "_RoomToUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_RoomToUser_AB_unique" ON "_RoomToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_RoomToUser_B_index" ON "_RoomToUser"("B");

-- AddForeignKey
ALTER TABLE "_RoomToUser" ADD CONSTRAINT "_RoomToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Room"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_RoomToUser" ADD CONSTRAINT "_RoomToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
/*
  Warnings:

  - Added the required column `name` to the `Room` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Room" ADD COLUMN     "name" TEXT NOT NULL;
/*
  Warnings:

  - You are about to drop the `_PastQuestion` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Room" DROP CONSTRAINT "Room_currentQuestionId_fkey";

-- DropForeignKey
ALTER TABLE "_PastQuestion" DROP CONSTRAINT "_PastQuestion_A_fkey";

-- DropForeignKey
ALTER TABLE "_PastQuestion" DROP CONSTRAINT "_PastQuestion_B_fkey";

-- AlterTable
ALTER TABLE "Room" ADD COLUMN     "hostId" TEXT;

-- DropTable
DROP TABLE "_PastQuestion";

-- CreateTable
CREATE TABLE "_QuestionToRoom" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_QuestionToRoom_AB_unique" ON "_QuestionToRoom"("A", "B");

-- CreateIndex
CREATE INDEX "_QuestionToRoom_B_index" ON "_QuestionToRoom"("B");

-- AddForeignKey
ALTER TABLE "_QuestionToRoom" ADD CONSTRAINT "_QuestionToRoom_A_fkey" FOREIGN KEY ("A") REFERENCES "Question"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_QuestionToRoom" ADD CONSTRAINT "_QuestionToRoom_B_fkey" FOREIGN KEY ("B") REFERENCES "Room"("id") ON DELETE CASCADE ON UPDATE CASCADE;
/*
  Warnings:

  - You are about to drop the column `displayedLink` on the `SearchResult` table. All the data in the column will be lost.
  - You are about to drop the column `link` on the `SearchResult` table. All the data in the column will be lost.
  - You are about to drop the column `snippet` on the `SearchResult` table. All the data in the column will be lost.
  - You are about to drop the column `title` on the `SearchResult` table. All the data in the column will be lost.
  - Added the required column `waybackUrl` to the `SearchResult` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "SearchResult" DROP COLUMN "displayedLink",
DROP COLUMN "link",
DROP COLUMN "snippet",
DROP COLUMN "title",
ADD COLUMN     "waybackUrl" TEXT NOT NULL;
-- CreateTable
CREATE TABLE "CalibrationQuestions" (
    "id" TEXT NOT NULL,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "content" TEXT NOT NULL,
    "answer" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL,
    "source" TEXT NOT NULL,

    CONSTRAINT "CalibrationQuestions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalibrationAnswer" (
    "id" TEXT NOT NULL,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "userId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "lowerBound" DOUBLE PRECISION NOT NULL,
    "upperBound" DOUBLE PRECISION NOT NULL,
    "score" DOUBLE PRECISION NOT NULL,
    "timeSpent" INTEGER DEFAULT 0,
    "correct" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CalibrationAnswer_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "CalibrationAnswer" ADD CONSTRAINT "CalibrationAnswer_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalibrationAnswer" ADD CONSTRAINT "CalibrationAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "CalibrationQuestions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
/*
  Warnings:

  - You are about to drop the `CalibrationQuestions` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "CalibrationAnswer" DROP CONSTRAINT "CalibrationAnswer_questionId_fkey";

-- DropTable
DROP TABLE "CalibrationQuestions";

-- CreateTable
CREATE TABLE "CalibrationQuestion" (
    "id" TEXT NOT NULL,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "content" TEXT NOT NULL,
    "answer" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL,
    "source" TEXT NOT NULL,

    CONSTRAINT "CalibrationQuestion_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "CalibrationAnswer" ADD CONSTRAINT "CalibrationAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "CalibrationQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;
/*
  Warnings:

  - You are about to drop the column `unit` on the `CalibrationQuestion` table. All the data in the column will be lost.
  - Added the required column `postfix` to the `CalibrationQuestion` table without a default value. This is not possible if the table is not empty.
  - Added the required column `prefix` to the `CalibrationQuestion` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "CalibrationQuestion" DROP COLUMN "unit",
ADD COLUMN     "postfix" TEXT NOT NULL,
ADD COLUMN     "prefix" TEXT NOT NULL,
ADD COLUMN     "useLogScoring" BOOLEAN NOT NULL DEFAULT false;
-- AlterTable
ALTER TABLE "CalibrationQuestion" ALTER COLUMN "source" SET DEFAULT E'',
ALTER COLUMN "postfix" SET DEFAULT E'',
ALTER COLUMN "prefix" SET DEFAULT E'';
-- AlterTable
ALTER TABLE "CalibrationAnswer" ADD COLUMN     "confidence" DOUBLE PRECISION NOT NULL DEFAULT 0.5;
-- AlterTable
ALTER TABLE "CalibrationQuestion" ADD COLUMN     "C" DOUBLE PRECISION NOT NULL DEFAULT 100;
-- CreateTable
CREATE TABLE "Challenge" (
    "id" TEXT NOT NULL,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "name" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Challenge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "challengeId" TEXT NOT NULL,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TeamFermiAnswer" (
    "id" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "skipped" BOOLEAN NOT NULL DEFAULT false,
    "lowerBound" DOUBLE PRECISION,
    "upperBound" DOUBLE PRECISION,
    "score" DOUBLE PRECISION NOT NULL,
    "timeSpent" INTEGER DEFAULT 0,
    "correct" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TeamFermiAnswer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CalibrationQuestionToChallenge" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_TeamToUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_CalibrationQuestionToChallenge_AB_unique" ON "_CalibrationQuestionToChallenge"("A", "B");

-- CreateIndex
CREATE INDEX "_CalibrationQuestionToChallenge_B_index" ON "_CalibrationQuestionToChallenge"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_TeamToUser_AB_unique" ON "_TeamToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_TeamToUser_B_index" ON "_TeamToUser"("B");

-- AddForeignKey
ALTER TABLE "Team" ADD CONSTRAINT "Team_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "Challenge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamFermiAnswer" ADD CONSTRAINT "TeamFermiAnswer_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamFermiAnswer" ADD CONSTRAINT "TeamFermiAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "CalibrationQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CalibrationQuestionToChallenge" ADD CONSTRAINT "_CalibrationQuestionToChallenge_A_fkey" FOREIGN KEY ("A") REFERENCES "CalibrationQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CalibrationQuestionToChallenge" ADD CONSTRAINT "_CalibrationQuestionToChallenge_B_fkey" FOREIGN KEY ("B") REFERENCES "Challenge"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_TeamToUser" ADD CONSTRAINT "_TeamToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_TeamToUser" ADD CONSTRAINT "_TeamToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
-- CreateTable
CREATE TABLE "AboveBelowQuestion" (
    "id" TEXT NOT NULL,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "content" TEXT NOT NULL,
    "answerIsAbove" BOOLEAN NOT NULL,
    "source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "AboveBelowQuestion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TeamAboveBelowAnswer" (
    "id" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "skipped" BOOLEAN NOT NULL DEFAULT false,
    "score" DOUBLE PRECISION NOT NULL,
    "timeSpent" INTEGER DEFAULT 0,
    "correct" BOOLEAN NOT NULL,
    "confidence" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TeamAboveBelowAnswer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_AboveBelowQuestionToChallenge" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_AboveBelowQuestionToChallenge_AB_unique" ON "_AboveBelowQuestionToChallenge"("A", "B");

-- CreateIndex
CREATE INDEX "_AboveBelowQuestionToChallenge_B_index" ON "_AboveBelowQuestionToChallenge"("B");

-- AddForeignKey
ALTER TABLE "TeamAboveBelowAnswer" ADD CONSTRAINT "TeamAboveBelowAnswer_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamAboveBelowAnswer" ADD CONSTRAINT "TeamAboveBelowAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "AboveBelowQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AboveBelowQuestionToChallenge" ADD CONSTRAINT "_AboveBelowQuestionToChallenge_A_fkey" FOREIGN KEY ("A") REFERENCES "AboveBelowQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AboveBelowQuestionToChallenge" ADD CONSTRAINT "_AboveBelowQuestionToChallenge_B_fkey" FOREIGN KEY ("B") REFERENCES "Challenge"("id") ON DELETE CASCADE ON UPDATE CASCADE;
/*
  Warnings:

  - Added the required column `quantity` to the `AboveBelowQuestion` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "AboveBelowQuestion" ADD COLUMN     "quantity" TEXT NOT NULL;
/*
  Warnings:

  - Added the required column `preciseAnswer` to the `AboveBelowQuestion` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "AboveBelowQuestion" ADD COLUMN     "preciseAnswer" DOUBLE PRECISION NOT NULL;
-- AlterTable
ALTER TABLE "CalibrationQuestion" ADD COLUMN     "challengeOnly" BOOLEAN NOT NULL DEFAULT false;
-- AlterTable
ALTER TABLE "AboveBelowQuestion" ALTER COLUMN "preciseAnswer" SET DATA TYPE TEXT;
-- CreateTable
CREATE TABLE "MailingListSubscriber" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tags" TEXT[],

    CONSTRAINT "MailingListSubscriber_pkey" PRIMARY KEY ("id")
);
-- AlterTable
ALTER TABLE "Challenge" ADD COLUMN     "unlisted" BOOLEAN NOT NULL DEFAULT false;
-- AlterTable
ALTER TABLE "Team" ADD COLUMN     "numPlayers" INTEGER NOT NULL DEFAULT 1;
-- AlterTable
ALTER TABLE "CalibrationAnswer" ADD COLUMN     "median" DOUBLE PRECISION;

-- CreateTable
CREATE TABLE "CalibrationQuestionTag" (
    "id" TEXT NOT NULL,
    "showInDeckSwitcher" BOOLEAN NOT NULL DEFAULT false,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "CalibrationQuestionTag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CalibrationQuestionToCalibrationQuestionTag" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_CalibrationQuestionToCalibrationQuestionTag_AB_unique" ON "_CalibrationQuestionToCalibrationQuestionTag"("A", "B");

-- CreateIndex
CREATE INDEX "_CalibrationQuestionToCalibrationQuestionTag_B_index" ON "_CalibrationQuestionToCalibrationQuestionTag"("B");

-- AddForeignKey
ALTER TABLE "_CalibrationQuestionToCalibrationQuestionTag" ADD CONSTRAINT "_CalibrationQuestionToCalibrationQuestionTag_A_fkey" FOREIGN KEY ("A") REFERENCES "CalibrationQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CalibrationQuestionToCalibrationQuestionTag" ADD CONSTRAINT "_CalibrationQuestionToCalibrationQuestionTag_B_fkey" FOREIGN KEY ("B") REFERENCES "CalibrationQuestionTag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
-- AlterTable
ALTER TABLE "Challenge" ADD COLUMN     "subtitle" TEXT;
-- AlterTable
ALTER TABLE "CalibrationQuestion" ADD COLUMN     "context" TEXT NOT NULL DEFAULT '';
-- AlterTable
ALTER TABLE "Pastcast" ADD COLUMN     "comment" TEXT;
-- CreateTable
CREATE TABLE "Feedback" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "email" TEXT,
    "userId" TEXT,

    CONSTRAINT "Feedback_pkey" PRIMARY KEY ("id")
);
-- AlterTable
ALTER TABLE "User" ADD COLUMN     "challengeLeaderboardBanned" BOOLEAN NOT NULL DEFAULT false;
-- AlterTable
ALTER TABLE "Challenge" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;
-- AlterTable
ALTER TABLE "MailingListSubscriber" ADD COLUMN     "name" TEXT,
ADD COLUMN     "products" TEXT[];
/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `MailingListSubscriber` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "MailingListSubscriber_email_key" ON "MailingListSubscriber"("email");
