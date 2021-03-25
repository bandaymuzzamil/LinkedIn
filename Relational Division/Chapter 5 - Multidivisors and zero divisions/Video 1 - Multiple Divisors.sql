----------------------------------------
-- LinkedIn Learning -------------------
-- Advanced SQL - Relational Division --
-- Ami Levin 2021 ----------------------
-- .\Chapter5\Video1.sql ---------------
----------------------------------------

USE HR;
GO

-- Multiple divisors: 
-- Show all candidates and roles, for which the candidate meets the role requirements.

-- Using aggregates
/* Original query for one divisor
WITH DBArchitectSkills 
AS
(
	SELECT	RS.Skill
	FROM	RoleSkills AS RS
	WHERE	RS.Role = 'DB Architect'
)
SELECT	CS.Candidate
FROM	CandidateSkills AS CS
		INNER JOIN
		DBArchitectSkills AS DBS
			ON DBS.Skill = CS.Skill
GROUP BY CS.Candidate
HAVING COUNT(*) = (SELECT COUNT(*) FROM DBArchitectSkills);
*/

WITH RoleSkillCounts AS
(
	SELECT	RS.Role, 
			COUNT(*) AS RoleSkillCount
	FROM	RoleSkills AS RS
	GROUP BY RS.Role
)
SELECT	CS.Candidate, RS.Role
FROM	CandidateSkills AS CS
		INNER JOIN 
		RoleSkills AS RS 
		ON RS.skill = CS.Skill
		INNER JOIN 
		RoleSkillCounts AS RSC 
		ON RS.Role = RSC.Role
GROUP BY CS.Candidate, RS.Role
HAVING COUNT(*) = (MAX(RoleSkillCount)); -- Dummy MAX aggregate, sorry...

-- Using set operators
/* Original query for one divisor
SELECT	C.Candidate
FROM	Candidates AS C
WHERE	NOT EXISTS	(
						SELECT	RS.Skill 
						FROM	RoleSkills AS RS
						WHERE	RS.Role = 'DB Architect'
						EXCEPT
						SELECT	CS.Skill
						FROM	CandidateSkills AS CS
						WHERE	CS.Candidate = C.Candidate
					);
*/
SELECT	C.Candidate, 
		R.Role
FROM	Candidates AS C
		CROSS JOIN		
		Roles AS R
WHERE	NOT EXISTS	(
						SELECT	RS.Skill
						FROM	RoleSkills AS RS
						WHERE	RS.Role = R.Role
						EXCEPT
						SELECT	CS.Skill
						FROM	CandidateSkills AS CS
						WHERE	C.Candidate = CS.Candidate
					);

-- Using nested subqueries
/* Original query for one divisor
SELECT 	C.Candidate
FROM 	Candidates AS C
WHERE 	NOT EXISTS	(
						SELECT 	NULL 
						FROM 	RoleSkills AS RS 
						WHERE 	RS.Role = 'DB Architect'
								AND 
								NOT EXISTS (
												SELECT 	NULL
												FROM 	CandidateSkills AS CS
												WHERE 	CS.Candidate = C.Candidate
														AND 
														CS.Skill = RS.Skill
											)
					);
*/

SELECT 	C.Candidate, 
		R.Role
FROM 	Candidates AS C
        CROSS JOIN 
        Roles AS R
WHERE 	NOT EXISTS	(
						SELECT 	NULL 
						FROM 	RoleSkills AS RS 
						WHERE 	RS.Role = R.Role
								AND 
								NOT EXISTS (
												SELECT 	NULL
												FROM 	CandidateSkills AS CS
												WHERE 	CS.Skill = RS.Skill
														AND 
														CS.Candidate = C.Candidate
											)
					);
							 
