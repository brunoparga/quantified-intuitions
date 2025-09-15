import NextAuth from "next-auth"
import type { NextAuthOptions, Session, User } from "next-auth"
import { JWT } from "next-auth/jwt"
import CredentialsProvider from "next-auth/providers/credentials"
import bcrypt from "bcryptjs"

import { PrismaAdapter } from "@next-auth/prisma-adapter"
import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(prisma),
  providers: [
    CredentialsProvider({
      name: "credentials",
      credentials: {
        username: { label: "Username", type: "text" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.username || !credentials?.password) {
          return null
        }

        const user = await prisma.user.findUnique({
          where: { username: credentials.username }
        })

        if (!user) {
          return null
        }

        const isPasswordValid = await bcrypt.compare(
          credentials.password,
          user.password
        )

        if (!isPasswordValid) {
          return null
        }

        return {
          id: user.id,
          username: user.username,
          name: user.name,
          email: user.email,
          image: user.image,
        }
      }
    }),
  ],
  theme: {
    colorScheme: "light",
    brandColor: "#4338ca",
    logo: "https://quantifiedintuitions.org/logo.png",
  },
  secret: process.env.NEXTAUTH_SECRET,
  session: {
    strategy: "jwt",
  },
  jwt: {
    secret: process.env.NEXTAUTH_SECRET,
  },
  callbacks: {
    session: async ({ session, token }) => {
      if (token.sub) {
        session.user.id = token.sub
      }
      if (token.username) {
        session.user.username = token.username
      }
      return session
    },
    jwt: async (params: { token: JWT; user?: User }) => {
      const { token, user } = params
      if (user) {
        token.sub = user.id
        token.username = (user as any).username
      }
      return token
    },
  },
}

export default NextAuth(authOptions)
