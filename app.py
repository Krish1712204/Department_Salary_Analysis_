import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# Load CSVs
employees = pd.read_csv("datasets/EmployeesTable.csv")
departments = pd.read_csv("datasets/DepartmentsTable.csv")

# Rename department name to avoid confusion
departments.rename(columns={"Name": "DepartmentName"}, inplace=True)
employees.rename(columns={"Name": "EmployeeName"}, inplace=True)

# Merge data on DepartmentID
merged_df = pd.merge(employees, departments, on="DepartmentID", how="inner")

# Group by DepartmentName
dept_stats = merged_df.groupby("DepartmentName").agg(
    AverageSalary=('Salary', 'mean'),
    NumberOfEmployees=('EmployeeID', 'count')
).reset_index()

# Calculate overall average salary
overall_avg = merged_df["Salary"].mean()

# Filter departments above average
filtered_df = dept_stats[dept_stats["AverageSalary"] > overall_avg]

# ---------------- Streamlit App ----------------

st.set_page_config(page_title="💼 Departmental Salary Dashboard", layout="wide")
st.title("💼 Departmental Salary Dashboard")

# Data Preview
st.subheader("📋 Raw Data")
with st.expander("Employees Table"):
    st.dataframe(employees)
with st.expander("Departments Table"):
    st.dataframe(departments)

# Result Table
st.subheader("🏆 Departments Above Average Salary")
st.dataframe(filtered_df)

# Average Salary Bar Chart
st.subheader("📊 Average Salary by Department")
st.bar_chart(dept_stats.set_index("DepartmentName")["AverageSalary"])

# Employee Count Bar Chart
st.subheader("👥 Employee Count by Department")
st.bar_chart(dept_stats.set_index("DepartmentName")["NumberOfEmployees"])

# Pie Chart
st.subheader("📈 Salary Distribution")
fig, ax = plt.subplots()
ax.pie(dept_stats["AverageSalary"], labels=dept_stats["DepartmentName"], autopct="%1.1f%%", startangle=90)
ax.axis("equal")
st.pyplot(fig)

# Download Button
st.subheader("⬇️ Download CSV")
csv = filtered_df.to_csv(index=False)
st.download_button("Download Filtered Departments", data=csv, file_name="AboveAvgDepartments.csv", mime="text/csv")
