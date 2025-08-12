/*
  Warnings:

  - You are about to drop the `UserFavoriteTasks` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "public"."UserFavoriteTasks" DROP CONSTRAINT "UserFavoriteTasks_taskId_fkey";

-- DropForeignKey
ALTER TABLE "public"."UserFavoriteTasks" DROP CONSTRAINT "UserFavoriteTasks_userId_fkey";

-- DropTable
DROP TABLE "public"."UserFavoriteTasks";

-- CreateTable
CREATE TABLE "public"."_UserFavorites" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_UserFavorites_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE INDEX "_UserFavorites_B_index" ON "public"."_UserFavorites"("B");

-- AddForeignKey
ALTER TABLE "public"."_UserFavorites" ADD CONSTRAINT "_UserFavorites_A_fkey" FOREIGN KEY ("A") REFERENCES "public"."Task"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."_UserFavorites" ADD CONSTRAINT "_UserFavorites_B_fkey" FOREIGN KEY ("B") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
