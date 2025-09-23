import { NextApiRequest, NextApiResponse } from "next";
import { Prisma } from "../../lib/prisma";

// Rate limiting storage (in production, use Redis or similar)
const rateLimitMap = new Map<string, { count: number; resetTime: number }>();


interface Request extends NextApiRequest {
  body: {
    name: string;
    challengeId: string;
  };
}

const createTeam = async (req: Request, res: NextApiResponse) => {  
  if (req.method !== "POST") {
    res.status(405).json({ error: "Method not allowed" });
    return;
  }

  const { name, challengeId } = req.body;
  
  if (
    typeof name !== "string" ||
    typeof challengeId !== "string"
  ) {
    res.status(400).json({
      error: `invalid request`,
    });
    return;
  }

  // Rate limiting by IP
  const clientIP = req.headers['x-forwarded-for'] || req.connection.remoteAddress || 'unknown';
  const now = Date.now();
  const rateLimitKey = `team_creation_${clientIP}`;
  const rateLimitData = rateLimitMap.get(rateLimitKey);

  if (rateLimitData) {
    if (now < rateLimitData.resetTime) {
      if (rateLimitData.count >= 5) { // Max 5 attempts per 15 minutes
        res.status(429).json({ error: "Too many attempts" });
        return;
      }
    } else {
      // Reset the counter
      rateLimitMap.set(rateLimitKey, { count: 0, resetTime: now + 15 * 60 * 1000 });
    }
  } else {
    rateLimitMap.set(rateLimitKey, { count: 0, resetTime: now + 15 * 60 * 1000 });
  }

  // Check if team name exists in the database for this challenge
  const validTeam = await Prisma.team.findFirst({
    where: {
      name,
      challengeId,
    },
  });

  if (!validTeam) {
    // Increment rate limit counter for invalid attempts
    const currentData = rateLimitMap.get(rateLimitKey)!;
    rateLimitMap.set(rateLimitKey, { 
      count: currentData.count + 1, 
      resetTime: currentData.resetTime 
    });
    
    res.status(403).json({ error: "Team name not found for this challenge" });
    return;
  }

  // Team name is valid, return the team ID
  res.status(200).json(validTeam.id);
};

export default createTeam;
