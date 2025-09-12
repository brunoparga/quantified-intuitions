export { default } from "next-auth/middleware"
// Require login on matching URLs:
export const config = {
  matcher: [
    "/admin",
    "/leaderboard", 
    "/settings",
    "/:id+", // any dynamic route with at least one segment (excludes root)
  ],
}
