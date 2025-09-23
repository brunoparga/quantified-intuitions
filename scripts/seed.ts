import { PrismaClient } from '@prisma/client'
import fs from 'fs'
import path from 'path'

const prisma = new PrismaClient()

interface ChallengeData {
  name: string
  subtitle: string
  teams: string[]
  calibrationQuestions: {
    content: string
    answer: number
    unit: string
    context: string
    source: string
    useLogScoring?: boolean
  }[]
  aboveBelowQuestions: {
    content: string
    answer: string
    baseValue: string
    context: string
    source: string
  }[]
}

function parseMarkdownFile(filePath: string): ChallengeData {
  const content = fs.readFileSync(filePath, 'utf-8')
  
  const lines = content.split('\n')
  let currentSection = ''
  const data: ChallengeData = {
    name: '',
    subtitle: '',
    teams: [],
    calibrationQuestions: [],
    aboveBelowQuestions: []
  }

  let currentQuestion: any = {}

  for (const line of lines) {
    const trimmed = line.trim()
    
    if (trimmed.startsWith('## Challenge Details')) {
      currentSection = 'challenge'
    } else if (trimmed.startsWith('## Teams')) {
      currentSection = 'teams'
    } else if (trimmed.startsWith('## Calibration Questions')) {
      currentSection = 'calibration'
    } else if (trimmed.startsWith('## Above/Below Questions')) {
      // Finalize any pending calibration question before switching
      if (currentSection === 'calibration' && Object.keys(currentQuestion).length > 0) {
        data.calibrationQuestions.push(currentQuestion)
        currentQuestion = {}
      }
      currentSection = 'aboveBelow'
    } else if (trimmed.startsWith('### Question')) {
      if (currentSection === 'calibration') {
        if (Object.keys(currentQuestion).length > 0) {
          data.calibrationQuestions.push(currentQuestion)
        }
        currentQuestion = {}
      } else if (currentSection === 'aboveBelow') {
        if (Object.keys(currentQuestion).length > 0) {
          data.aboveBelowQuestions.push(currentQuestion)
        }
        currentQuestion = {}
      }
    } else if (trimmed.startsWith('- **')) {
      const match = trimmed.match(/- \*\*([^*]+)\*\*: (.+)/)
      if (match) {
        const [, key, value] = match
        const cleanKey = key.toLowerCase().replace(/\s+/g, '')
        
        if (currentSection === 'challenge') {
          if (cleanKey === 'name') data.name = value
          else if (cleanKey === 'subtitle') data.subtitle = value
        } else if (currentSection === 'calibration') {
          if (cleanKey === 'content') currentQuestion.content = value
          else if (cleanKey === 'answer') currentQuestion.answer = parseFloat(value)
          else if (cleanKey === 'unit') currentQuestion.unit = value
          else if (cleanKey === 'context') currentQuestion.context = value
          else if (cleanKey === 'source') currentQuestion.source = value
          else if (cleanKey === 'uselogscoring') currentQuestion.useLogScoring = value.toLowerCase() === 'true'
        } else if (currentSection === 'aboveBelow') {
          if (cleanKey === 'content') currentQuestion.content = value
          else if (cleanKey === 'answer') currentQuestion.answer = value
          else if (cleanKey === 'basevalue') currentQuestion.baseValue = value
          else if (cleanKey === 'context') currentQuestion.context = value
          else if (cleanKey === 'source') currentQuestion.source = value
        }
      }
    } else if (trimmed.startsWith('- ') && currentSection === 'teams') {
      const teamName = trimmed.replace('- ', '')
      if (teamName) data.teams.push(teamName)
    }
  }

  // Add the last question if it exists
  if (currentSection === 'calibration' && Object.keys(currentQuestion).length > 0) {
    data.calibrationQuestions.push(currentQuestion)
  } else if (currentSection === 'aboveBelow' && Object.keys(currentQuestion).length > 0) {
    data.aboveBelowQuestions.push(currentQuestion)
  }

  return data
}

async function seed() {
  try {
    console.log('🌱 Starting database seed...')

    // Clear existing data
    await prisma.teamAboveBelowAnswer.deleteMany()
    await prisma.teamFermiAnswer.deleteMany()
    await prisma.team.deleteMany()
    await prisma.aboveBelowQuestion.deleteMany()
    await prisma.calibrationQuestion.deleteMany()
    await prisma.challenge.deleteMany()

    // Parse markdown file
    const dataPath = path.join(process.cwd(), 'data', 'challenge-data.md')
    const data = parseMarkdownFile(dataPath)

    // Create challenge
    const challenge = await prisma.challenge.create({
      data: {
        name: data.name,
        subtitle: data.subtitle,
      }
    })

    console.log(`✅ Created challenge: ${challenge.name}`)

    // Create calibration questions
    for (const q of data.calibrationQuestions) {
      // The C parameter controls the scoring scale:
      // - For linear scoring: C is the unit scale (e.g., 100 = 100 units per point)
      // - For log scoring: C is the base for logarithmic calculations (e.g., 10 = each order of magnitude)
      // Large numbers (millions) need log scoring with C=10, smaller numbers use linear with C=100
      
      await prisma.calibrationQuestion.create({
        data: {
          content: q.content,
          answer: q.answer,
          prefix: '',
          postfix: q.unit ? ` ${q.unit}` : '',
          context: q.context,
          source: q.source,
          useLogScoring: q.useLogScoring || false,
          C: q.useLogScoring ? 10 : 100,
          challenges: {
            connect: { id: challenge.id }
          }
        }
      })
    }

    console.log(`✅ Created ${data.calibrationQuestions.length} calibration questions`)

    // Create above/below questions
    for (const q of data.aboveBelowQuestions) {
      await prisma.aboveBelowQuestion.create({
        data: {
          content: q.content,
          quantity: `${q.baseValue}`,
          answerIsAbove: q.answer > q.baseValue,
          preciseAnswer: `${q.answer}`,
          context: q.context,
          source: q.source,
          challenges: {
            connect: { id: challenge.id }
          }
        }
      })
    }

    console.log(`✅ Created ${data.aboveBelowQuestions.length} above/below questions`)

    // Create teams
    for (const teamName of data.teams) {
      await prisma.team.create({
        data: {
          name: teamName,
          challengeId: challenge.id
        }
      })
    }

    console.log(`✅ Created ${data.teams.length} teams`)

    console.log('🎉 Database seeded successfully!')
  } catch (error) {
    console.error('❌ Error seeding database:', error)
    process.exit(1)
  } finally {
    await prisma.$disconnect()
  }
}

seed()
