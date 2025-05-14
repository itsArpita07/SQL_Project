WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(*) AS demand_count
    FROM 
        job_postings_fact
    JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY 
        skills_dim.skill_id, skills_dim.skills
),
average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
    FROM 
        job_postings_fact
    JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE 
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY 
        skills_job_dim.skill_id
)
SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM 
    skills_demand
JOIN 
    average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    skills_demand.demand_count > 10
ORDER BY 
    average_salary.avg_salary DESC,
    skills_demand.demand_count DESC
LIMIT 25;
