# 📊 Data Analyst Job Market Analysis in the US

## 📝 Introduction

The landscape of **Data Analyst** job opportunities has evolved rapidly in recent years. The rise of **remote work** and an increasing reliance on data-driven decision-making across industries have created new dynamics in the job market. This project provides a detailed analysis of the **U.S. Data Analyst job market**, utilizing publicly available datasets to uncover key trends related to **skills**, **salary expectations**, **location preferences**, and **remote work**.

By leveraging the **Luke Barousse's Data Jobs Dataset** from Hugging Face, this analysis focuses on understanding the **key factors** influencing Data Analyst job postings across the country. The goal is to help data professionals make informed career decisions by identifying high-demand skills, understanding geographic and salary differences, and exploring the impact of remote work.

## 🧑‍💻 Background 

In recent years, the demand for **Data Analysts** has surged, driven by the increasing importance of **data-driven decision-making**. With the growth of **big data** and **artificial intelligence (AI)**, Data Analysts have become crucial in transforming raw data into actionable insights. Companies now prioritize a combination of **technical skills** (SQL, Python, data visualization tools) and **business acumen** to interpret and communicate data effectively.

The **Luke Barousse's Data Jobs Dataset** offers detailed insights into **job postings** for Data Analysts, covering:
- 📍 **Job titles** and descriptions
- 🏢 **Company names** and locations
- 🛠️ **Required skills**
- 💸 **Salary information**
- 📅 **Job posting dates** and **work schedule types**

By analyzing this dataset, the goal is to identify trends such as:
- 🔍 **Which skills** are most in-demand
- 💵 **Salary differences** across various regions
- 🌍 The impact of **remote work** on Data Analyst roles

## ❓ Key Questions Addressed

1. **What are the top job postings for Data Analysts with the highest average salaries?**


2. **What are the top-paying Data Analyst jobs by company, and which skills are required?**


3. **Which skills are in high demand for Data Analysts, and how do they correlate with salary expectations?**
 

4. **What are the skills that offer the highest average salary for Data Analysts?**
 

5. **What skills are in demand for remote Data Analyst roles, and how do they compare in terms of salary?**


## 📂 Dataset Source:
[Luke Barousse's Data Jobs Dataset](https://huggingface.co/datasets/lukebarousse/data_jobs)

## 🛠️ Tools Used

- **🔍 PostgreSQL**: Used for querying and analyzing the job posting dataset.
- **💻 VSCode**: Used as the IDE for writing and executing SQL queries.
- **📝 SQL**: Used for querying, aggregating, and analyzing the data.
- **🌐 GitHub**: Used for version control and storing the project repository.

## 📈 Analysis

In this section, we will dive into the analysis of the Data Analyst job market based on the queries provided. Each query is designed to extract valuable insights from the dataset and answer key questions related to job postings, skills demand, and salary trends. 

### **1. Top 10 Data Analyst Job Postings by Salary**

The objective of this query is to retrieve the top 10 job postings for Data Analyst positions, sorted by the highest average yearly salary. The query filters by job title and job location (anywhere), ensuring that the salary data is not null. It uses a `LEFT JOIN` to combine `job_postings_fact` with the `company_dim` table to get the company names.

```sql
SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### Insights

- **Mantys** offers the highest salary for a **Data Analyst** role at **$650,000** annually. This is a fully remote position posted on **2023-02-20**.
- **Meta** offers a **Director of Analytics** role with a **$336,500** salary, available remotely, posted on **2023-08-23**.
- **AT&T** is offering **$255,829.50** for an **Associate Director - Data Insights** role, posted on **2023-06-18**.

These postings show a significant salary range, with positions offering anywhere from **$184,000** to **$650,000** annually. The higher-paying roles often come with more senior titles or specialized expertise.

### **2. Top-Paying Data Analyst Jobs by Company and Their Required Skills**

The objective of this query is to retrieve the top-paying job postings for Data Analyst roles, focusing on jobs that are remote (location: "Anywhere"). It identifies the highest average yearly salaries and the associated companies. The query first selects the top 10 highest-paying job postings using a `LEFT JOIN` between the `job_postings_fact` and `company_dim` tables to obtain company names. It then uses `INNER JOIN`s with `skills_job_dim` and `skills_dim` to fetch the required skills for those jobs.

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        name AS company_name,
        job_location,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*, skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY top_paying_jobs.salary_year_avg DESC;
```
### Insights

- **AT&T** offers an **Associate Director - Data Insights** role with a high salary of **$255,829.50** annually. This is a fully remote position requiring skills such as SQL, Python, R, Azure, AWS, Databricks, Power BI, Tableau, and more.
- **Pinterest Job Advertisements** lists a **Data Analyst, Marketing** position with a salary of **$232,423**, also remote. Key skills include SQL, Python, R, Hadoop, and Tableau.
- **UCLA Health Careers** offers a **Data Analyst (Hybrid/Remote)** role paying **$217,000** per year. Required tools include SQL, Crystal Reports, Oracle, Tableau, and Flow.


These postings highlight that high-paying roles (above $180,000 annually) often require advanced data handling skills, cloud tools (AWS, Azure), and visualization platforms (Tableau, Power BI), with many opportunities offered in remote or hybrid formats.

### **3. Skills in High Demand for Data Analysts and Their Correlation with Salary Expectations**

The objective of this query is to identify the skills in high demand for Data Analysts and determine how these skills correlate with salary expectations. The query first joins the `job_postings_fact`, `skills_job_dim`, and `skills_dim` tables to gather the skills required for Data Analyst roles. It then calculates the demand for each skill by counting the number of job postings that require it and computes the average salary for those roles. Finally, the results are ordered by the demand count in descending order, limiting the output to the top 10 skills.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
        INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10;
```
### Insights

- **SQL** is the most in-demand skill with **3083** job postings and an **average salary of $96,435.33**. It is essential for most data analysis roles.
- **Python** follows closely with **1840** job postings and an **average salary of $101,511.85**, emphasizing its significance in data science and automation.
- **Excel** is also crucial, with **2143** job postings and an **average salary of $86,418.90**, highlighting its importance in data manipulation and reporting.

These findings suggest that **SQL**, **Python**, and **Excel** are critical for securing high-paying Data Analyst positions, with visualization tools like **Tableau** also contributing to competitive salaries.

### **4. Top-Paying Skills for Data Analysts**

The objective of this query is to identify the technical skills that command the highest average salaries for Data Analyst roles. It joins the `job_postings_fact`, `skills_job_dim`, and `skills_dim` tables to associate each job posting with its listed skills. The query filters for job postings with the title **"Data Analyst"** and non-null salary data. It then groups the data by skill, calculates the average salary for each skill, and orders the results in descending order of average salary. The top 30 highest-paying skills are returned.

```sql
SELECT 
    skills, 
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
LIMIT 30;
```
### Insights

- **SVN** stands out with an exceptionally high average salary of **$400,000**, indicating a niche but extremely lucrative demand—likely tied to legacy systems in specialized industries.
- **Solidity**, the smart contract programming language for blockchain platforms like Ethereum, offers an average salary of **$179,000**, suggesting high compensation for blockchain-related analytical roles.
- **Couchbase**, a NoSQL database platform, ranks third with an average salary of **$160,515**, reflecting its growing adoption in enterprise-scale, real-time data processing environments.

### **5. In-Demand Skills for Remote Data Analyst Roles and Their Salary Comparison**

This query identifies the most in-demand skills for remote Data Analyst roles and compares them based on average salary. It uses two Common Table Expressions (CTEs):

- `skills_demand`: Counts how many remote job postings require each skill.
- `average_salary`: Calculates the average salary for each skill used in remote job postings.

The final result joins both CTEs, filters out skills with low demand (≤10 postings), and returns the top 25 skills ordered by highest average salary.

```sql
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
```

### Top 10 Skills in Demand for Remote Data Analyst Roles

<table border="1">
  <tr>
    <th>Skill ID</th>
    <th>Skills</th>
    <th>Demand Count</th>
    <th>Average Salary</th>
  </tr>
  <tr>
    <td>8</td>
    <td>Go</td>
    <td>27</td>
    <td>$115,319.89</td>
  </tr>
  <tr>
    <td>234</td>
    <td>Confluence</td>
    <td>11</td>
    <td>$114,209.91</td>
  </tr>
  <tr>
    <td>97</td>
    <td>Hadoop</td>
    <td>22</td>
    <td>$113,192.57</td>
  </tr>
  <tr>
    <td>80</td>
    <td>Snowflake</td>
    <td>37</td>
    <td>$112,947.97</td>
  </tr>
  <tr>
    <td>74</td>
    <td>Azure</td>
    <td>34</td>
    <td>$111,225.10</td>
  </tr>
  <tr>
    <td>77</td>
    <td>BigQuery</td>
    <td>13</td>
    <td>$109,653.85</td>
  </tr>
  <tr>
    <td>76</td>
    <td>AWS</td>
    <td>32</td>
    <td>$108,317.30</td>
  </tr>
  <tr>
    <td>4</td>
    <td>Java</td>
    <td>17</td>
    <td>$106,906.44</td>
  </tr>
  <tr>
    <td>194</td>
    <td>SSIS</td>
    <td>12</td>
    <td>$106,683.33</td>
  </tr>
  <tr>
    <td>233</td>
    <td>Jira</td>
    <td>20</td>
    <td>$104,917.90</td>
  </tr>
</table>


### Insights

- **Python** stands out as the most in-demand skill for remote Data Analyst roles, with **236** job postings and an average salary of **$101,397.22**. This reflects the high value placed on Python for data manipulation and analysis tasks.
- **Go** offers the highest average salary at **$115,319.89**, with **27** job postings, indicating a strong demand for high-performance, scalable solutions in data analytics.
- **Snowflake**, with **37** job postings and an average salary of **$112,947.97**, highlights its growing importance in cloud-based data warehousing and analytics, signaling a shift toward cloud-native technologies in the data field.


## 🧠 What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- 🧩 **Complex Query Crafting**: Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- 📊 **Data Aggregation**: Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- 💡 **Analytical Wizardry**: Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

## 📚 Conclusions

From the analysis, several general insights emerged:

- **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at **$650,000**!
- **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
- **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
- **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
- **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
