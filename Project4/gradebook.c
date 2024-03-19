#include "gradebook.h"
#include <string.h>

/*
 * Name: Devonte Billings
 */

struct Gradebook gradebook;

/**
 * Adds a new student to the gradebook and sets all the student's grades to 0.
 *
 * Updates assignment_averages and course_average based on the new grades.
 *
 * @param name The name of the student.
 * @param gtid The GTID of the student.
 * @param year The year of the student.
 * @param major The major of the student.
 * @return SUCCESS if the student is added, otherwise ERROR if the student can't
 * be added (duplicate name / GTID, no space in gradebook, invalid major).
 */
int add_student(char *name, int gtid, int year, char *major) {
  // TODO: Implement this function
  UNUSED(name);
  UNUSED(gtid);
  UNUSED(year);
  UNUSED(major);
  
  if (name == NULL){
    return ERROR;
  }

  if (major== NULL){
    return ERROR;
  }

  struct Student student;
  if(strlen(name) >= MAX_NAME_LENGTH){
      return ERROR;
    }
 

  for(int i=0;i<(int)strlen(name);i+=1){
    student.name[i] = name[i];
    printf("%s\n",student.name);
    
  }
  printf("-------------------\n");
  student.gtid = gtid;
  student.year = year;

  
  int maj = -1;

  for (int j=0;j<4;j+=1) {
      char *target;
      if (j == 0){
        target = "CS";
      }
      else if (j == 1){
        target = "CE";
      }
      else if (j == 2){
        target = "EE";
      }
      else {  
        target = "IE";
      }
      
      char cletter = *major;
      char tletter = *target;
      
      int success = 1;
      int k= 0;
      while(cletter != 0) {
        cletter = (char)*(major + k);
        tletter = (char)*(target + k);
        if (cletter != tletter){
          success = 0;
          break;
        }
        k+=1;
      }

      if (success == 1){
        maj = j;
        break;
      }
  }
  if (maj == -1){
    return ERROR;
  }
  
  student.major = maj;
  struct GradebookEntry gradebookEntry;
  gradebookEntry.average = 0;

  if (gradebook.size >=MAX_ENTRIES){
    return ERROR;
  }
  
  for (int l=0;l<gradebook.size;l+=1){
    struct Student stud = gradebook.entries[l].student;
    if(stud.gtid == gtid){
      return ERROR;
    }

    if (strlen(name) == strlen(stud.name) || (strcmp(name,stud.name) == 0)){
      if(strlen(name) == strlen(stud.name) && (strcmp(name,stud.name) == 0)){
        return ERROR;
      }
    }
  }
  
  
  
  gradebook.entries[gradebook.size] = gradebookEntry;
  gradebook.size += 1;
  return SUCCESS;
  
}

/**
 * Updates the grade of a specific assignment for a student and updates that
 * student's average grade.
 * 
 * Ensure that the overall course averages are still up-to-date after these grade updates.
 *
 * @param name The name of the student.
 * @param assignmentType The type of assignment.
 * @param newGrade The new grade.
 * @return SUCCESS if the grade is updated, otherwise ERROR if the grade isn't (student not found).
 */
int update_grade(char *name, enum Assignment assignment_type, double new_grade) {
  // TODO: Implement this function
  UNUSED(name);
  UNUSED(assignment_type);
  UNUSED(new_grade);

  for (int l=0; l<gradebook.size; l+=1) {
    struct Student stud = gradebook.entries[l].student;

    if (strlen(name) == strlen(stud.name) || (strcmp(name,stud.name) == 0)){
      if(strlen(name) == strlen(stud.name) && (strcmp(name,stud.name) == 0)){
        gradebook.entries[l].grades[assignment_type] = new_grade;
        calculate_course_average();
        return SUCCESS;
            }
          }
        }
  return ERROR;
}

/**
 * Adds a new student to the gradebook and initializes each of the student's
 * grades with the grades passed in.
 *
 * Additionally, will update the overall assignment_averages and course_average
 * based on the new added student.
 *
 * @param name The name of the student.
 * @param gtid The GTID of the student.
 * @param year The year of the student.
 * @param major The major of the student.
 * @param grades An array of grades for the student.
 * @return SUCCESS if the student is added and the averages updated, otherwise ERROR if the student can't
 * be added (duplicate name / GTID, no space in gradebook, invalid major).
 */
int add_student_with_grades(char *name, int gtid, int year, char *major,
                            double *grades) {
  // TODO: Implement this function
  UNUSED(name);
  UNUSED(gtid);
  UNUSED(year);
  UNUSED(major);
  UNUSED(grades);
  if (name == NULL){
    return ERROR;
  }

  if (major== NULL){
    return ERROR;
  }

  struct Student student;
  
  char letter = *name;
    int i = 0;

  if(strlen(name) >= MAX_NAME_LENGTH){
      return ERROR;
    }

  while (letter != 0){
    student.name[i] = letter;
    i+=1;
    letter = (char)*(name + i);
    
  }
  student.gtid = gtid;
  student.year = year;
  
  int maj = -1;

  for (int j=0;j<4;j+=1) {
      char *target;
      if (j == 0){
        target = "CS";
      }
      else if (j == 1){
        target = "CE";
      }
      else if (j == 2){
        target = "EE";
      }
      else {  
        target = "IE";
      }
      
      char cletter = *major;
      char tletter = *target;
      
      int success = 1;
      int k= 0;
      while(cletter != 0) {
        cletter = (char)*(major + k);
        tletter = (char)*(target + k);
        if (cletter != tletter){
          success = 0;
          break;
        }
        k+=1;
      }

      if (success == 1){
        maj = j;
        break;
      }
  }
  if (maj == -1){
    return ERROR;
  }
  
  student.major = maj;
  
  struct GradebookEntry gradebookEntry;
  gradebookEntry.student = student;
  gradebookEntry.average = 0;

  if (gradebook.size >=MAX_ENTRIES){
    return ERROR;
  }
  
  for (int l=0;l<gradebook.size;l+=1){
    struct Student stud = gradebook.entries[l].student;
    if(stud.gtid == gtid){
      return ERROR;
    }

    if (strlen(name) == strlen(stud.name) || (strcmp(name,stud.name) == 0)){
      if(strlen(name) == strlen(stud.name) && (strcmp(name,stud.name) == 0)){
        return ERROR;
      }
    }
  }
    
  

  for (int i=0; i<5; i+=1) {
    gradebookEntry.grades[i] = *(grades + i);
  }
  
  gradebook.entries[gradebook.size] = gradebookEntry;
  gradebook.size += 1;
  calculate_course_average();
  printf("%f\n",gradebook.entries[gradebook.size].average);
  return SUCCESS;

  //make run-case TEST=TEST_add_student_with_grades
}

/**
 * Calculates the average grade for a specific gradebook entry and updates the
 * struct as appropriate.
 *
 * @param entry The gradebook entry for which to recalculate the average.
 * @return SUCCESS if the average is updated, ERROR if pointer is NULL
 */
int calculate_average(struct GradebookEntry *entry) {
  // TODO: Implement this function
  UNUSED(entry);

  if(entry == NULL){
    return ERROR;
  }

  struct GradebookEntry entr = *entry;
  double total = 0;
  for (int i=0;i<5;i+=1) {
    total += entr.grades[i]*gradebook.weights[i];
  } 
  
  entr.average = total;
  *entry = entr;
  
  return SUCCESS;

  //make run-case TEST=TEST_calculate_average
}

/**
 * Calculates and update the overall course average and assignment averages. 
 * The average should be calculated by taking the averages of the student's 
 * averages, NOT the assignment averages.
 *
 * If the gradebook is empty, set the course and assignment averages to 0
 * and return ERROR.
 * 
 * @return SUCCESS if the averages are calculated properly, ERROR if gradebook
 * is empty
 */
int calculate_course_average(void) {
  // TODO: Implement this function
  if(gradebook.size == 0){
    return ERROR;
  }
  double course_average = 0;
  double assignment_averages[NUM_ASSIGNMENTS] = {0,0,0,0,0};
  for (int i=0; i<gradebook.size;i+=1){
    calculate_average(&gradebook.entries[i]);
    struct GradebookEntry entry = gradebook.entries[i];
    course_average += entry.average;
    
    for (int j=0;j<NUM_ASSIGNMENTS;j+=1){
      assignment_averages[j] += entry.grades[j];
    }
  }
  for(int k=0;k<NUM_ASSIGNMENTS;k+=1) {
    
    gradebook.assignment_averages[k] = assignment_averages[k]/gradebook.size;
  }
  gradebook.course_average = course_average/gradebook.size;
  return SUCCESS;
  //make run-case TEST=TEST_calculate_course_average

}

/**
 * Searches for a student in the gradebook by name.
 *
 * @param name The name of the student.
 * @return The index of the student in the gradebook, or ERROR if not found.
 */
int search_student(char *name) {
  // TODO: Implement this function
  UNUSED(name);
  if(name == NULL){
    return ERROR;
  }
  for (int l=0;l<gradebook.size;l+=1){
    struct Student stud = gradebook.entries[l].student;
    
    if (strlen(name) == strlen(stud.name) || (strcmp(name,stud.name) == 0)){
      if(strlen(name) == strlen(stud.name) && (strcmp(name,stud.name) == 0)){
        return l;
      }
    }
  }
  return ERROR;
  //make run-case TEST=TEST_search_student
}

/**
 * Remove a student from the gradebook while maintaining the ordering of the gradebook.
 *
 * Additionally, update the overall assignment_averages and course_average
 * based on the removed student and decrement the size of gradebook.
 *
 * If the gradebook is empty afterwards, SUCCESS should still be returned and
 * averages should be set to 0.
 *
 * @param name The name of the student to be withdrawn.
 * @return SUCCESS if the student is successfully removed, otherwise ERROR if
 * the student isn't found.
 */
int withdraw_student(char *name) {
  // TODO: Implement this function
  UNUSED(name);
  if(name == NULL){
    return ERROR;
  }
  for(int i=0;i<gradebook.size-1;i+=1){
          printf("%s->",gradebook.entries[i].student.name);
        }
  printf("%s\n",gradebook.entries[gradebook.size-1].student.name);
  for (int l=0;l<gradebook.size;l+=1){
    struct Student stud = gradebook.entries[l].student;
    
    if (strlen(name) == strlen(stud.name) || (strcmp(name,stud.name) == 0)){
      if(strlen(name) == strlen(stud.name) && (strcmp(name,stud.name) == 0)){

        for(int i=l;i<gradebook.size;i+=1) {
          gradebook.entries[i] = gradebook.entries[i+1];
        }
        gradebook.size -= 1;
        calculate_course_average();
        return SUCCESS;
      }
    }
  }
  return ERROR;
  //make run-case TEST=TEST_withdraw_student
}

/**
 * Populate the provided array with the GTIDs of the 5 students with the highest
 * grades. The GTIDs should be placed in descending order of averages. 
 * 
 * If unable to populate the full array (less than 5 students in gradebook), 
 * fill in the remaining values with INVALID_GTID.
 *
 * @param gtids An array to store the top five gtids.
 * @return SUCCESS if gtids are found, otherwise ERROR if gradebook is empty
 */
int top_five_gtid(int *gtids) {
  // TODO: Implement this function
  UNUSED(gtids);
  if(gradebook.size == 0){
    return ERROR;
  }
  int count = 0;
  for(int i=0; i<5;i+=1){
    int max = -1;
    for(int j=0;j<gradebook.size;j+=1){
      struct GradebookEntry entry = gradebook.entries[j];
      if (entry.average > max){
        int found = -1;
        for(int k=0;k<count;k+=1){
          if(entry.student.gtid == gtids[k]){
            found = 1;
            break;
          }
        }
        if (found==1){
          continue;
        }
        max = entry.average;
        gtids[count] = entry.student.gtid;
      }
    }
    count+=1;
  }
  for(int l=0;l<count;l+=1){
    if(gtids[l] == 0){
      gtids[l] = INVALID_GTID;
    }
  }
  for(int l=count;l<5;l+=1){
  }
  return SUCCESS;
  //make run-case TEST=TEST_top_five_gtid_few_entries
}

/**
 * Sorts the gradebook entries by name in alphabetical order (First, Last).
 *
 * @return SUCCESS if names are sorted, ERROR is gradebook is empty.
 */
int sort_name(void) {
  // TODO: Implement this function
  if (gradebook.size == 0){
    return ERROR;
  }
  for(int i=0; i<gradebook.size-1;i+=1){
    int t = i;

    for(int j=i+1;j<gradebook.size;j+=1){
      char *min = gradebook.entries[t].student.name;
      char *curr = gradebook.entries[j].student.name;
      if (strcmp(min,curr) > 0){
        t = j;
      }
    }
    for(int k=0;k<gradebook.size;k+=1){
      printf("%s->",gradebook.entries[k].student.name);
    }
    printf("\n");
    printf("Need to switch %s and %s\n\n", gradebook.entries[i].student.name, gradebook.entries[t].student.name);
    if(t != i){
      struct GradebookEntry hold = gradebook.entries[i];
      gradebook.entries[i] = gradebook.entries[t];
      gradebook.entries[t] = hold;
    }
    
  }
  for(int k=0;k<gradebook.size;k+=1){
    printf("%s->",gradebook.entries[k].student.name);
  }
  printf("\n");
  return SUCCESS;
  //make run-case TEST=TEST_sort_averages
}

/**
 * Sorts the gradebook entries by average grades in descending order.
 *
 * @return SUCCESS if entries are sorted, ERROR if gradebook is empty.
 */
int sort_averages(void) {
  // TODO: Implement this function
  if (gradebook.size == 0){
    return ERROR;
  }
  for(int i=0; i<gradebook.size-1;i+=1){
    int t = i;

    for(int j=i+1;j<gradebook.size;j+=1){
      int min = gradebook.entries[t].average;
      int curr = gradebook.entries[j].average;

      if (min < curr){
        t = j;
      }
    }
    for(int k=0;k<gradebook.size;k+=1){
      printf("%f->",gradebook.entries[k].average);
    }
    printf("\n");
    printf("Need to switch %f and %f\n\n", gradebook.entries[i].average, gradebook.entries[t].average);
    if(t != i){
      struct GradebookEntry hold = gradebook.entries[i];
      gradebook.entries[i] = gradebook.entries[t];
      gradebook.entries[t] = hold;
    }
    
  }
  return SUCCESS;


  
}

/**
 * Prints the entire gradebook in the format
 * student_name,major,grade1,grade2,...,student_average\n
 * 
 * Overall Averages:
 * grade1_average,grade2_average,...,course_average\n
 * 
 * Note 1: The '\n' shouldn’t print, just represents the newline for this example.
 * Note 2: There is an empty line above the “Overall Averages:” line.
 * 
 * All of the floats that you print must be manually rounded to 2 decimal places.
 *
 * @return SUCCESS if gradebook is printed, ERROR if gradebook is empty.
 */
int print_gradebook(void) {
  // TODO: Implement this function
  if(gradebook.size==0){return ERROR;}
  for (int i=0; i<gradebook.size;i+=1) {
    struct GradebookEntry entry = gradebook.entries[i];
    struct Student student = gradebook.entries[i].student;
    printf("%s,",student.name);
    char *major;
    if (student.major == 0){
        major = "CS";
      }
      else if (student.major == 1){
        major = "CE";
      }
      else if (student.major == 2){
        major = "EE";
      }
      else {  
        major = "IE";
      }
      
    printf("%s,",major);
    for(int k=0;k<5;k+=1){
      printf("%.2f,",entry.grades[k]);
    }
    printf("%.2f",entry.average);
    printf("\n");
  }
  
  printf("\nOverall Averages: \n");
  for(int j=0;j<5;j+=1){
    printf("%.2f,",gradebook.assignment_averages[j]);
  }
  printf("%.2f\n",gradebook.course_average);
  
  return SUCCESS;
  //make run-case TEST=TEST_print_gradebook
}
