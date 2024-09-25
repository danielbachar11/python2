# הרצת TERRAFORM  לפריסה של VM ו BUCKET ב GCP באמצעות GITHUB ACTION 
## פירוט המשימה
הרצת מכונה וירטואלית ו bucket ב gcp
## שלבים 

- **שלב ראשון**: יצירת תיקיות ל RESOURCE שלנו 
- **שלב שני**: יצירת קבצי הגדרות של TERRAFORM 
- **שלב שלישי**: יצירת קובץ PIPLINE 


## דרישות מקדימות
שיהיה מותקן TERRAFORM ב RUNNER שלנו 


## שלבים

- **שלב ראשון**:
ניצור תיקיות ל משאבים שלנו 
1 mock_devops_tasks/terraform/us-central1/bucket \
2 mock_devops_tasks/terraform/us-central1/vm \
- **שלב שני**: יצירת קבצי הגדרות של TERRAFORM 

ניצור את הקבצים הבאים בתוך כל תיקייה שמכילה את הדברים  הבאים \
   1- ניצור קובץ ראשון שמכיל את פירוט המשאבים שלנו בשם terraform.tf \
   2- ניצור קובץ שמכיל את פרטי ספק הענן שלנו בשם  provider.tf \
   3- ניצור קובץ משתנים בשם variables.tf \
   4- קובץ OUTPUT שמציג לנו את המשאבים שנוצרו וניקרא לו output.tf

- **שלב שלישי**: יצירת קובץ PIPLINE \
ניצור PIPLINE עם INPUT עם ערכים ל TERRAFORM שלנו שיעשה PLAN APPLY DESTROY למשאבים שלנו 

```bash
    
name: terraform ci 
on:
  workflow_dispatch:
    inputs:
      tfcmd:
        description: 'terraform command to run'
        required: true       
        type: choice
        options:
          - plan
          - apply -auto-approve 
          - destroy


  
jobs:
  apply_terraform_on_gcp:
    runs-on: [self-hosted,Linux,X64]
    steps:
      - name: Check out the repository
        uses: actions/checkout@v4
        
      - name: apply resorce to google cloud using terraform
        env:
          GCP_SECRET: ${{ secrets.GCP_SECRET }}
        run: | 
          for d in $(find terraform -type d -maxdepth 2 -path "terraform/*/*"); do
            echo "$GCP_SECRET" > .$pwd/$d/gke.json
            echo "runing on .$pwd/$d"
            terraform -chdir=.$pwd/$d init
            terraform -chdir=.$pwd/$d ${{ inputs.tfcmd }}; 
          done
       
```
בגלל שיש לנו שתי תיקיות תחת תיקיית TERRAFORM נצטרך לעשות FOR LOOP שמחפש את תיקיות תיקיות ה TERRAFORM שלנו ומריץ עליהם פקודות TERRAFORM \
בשביל להכניס את את ה CREDENTIALS של GCP יצרתי SERVICE ACCOUNT ונתתי לו את ההרשאות שצריך ואז יצרתי SECRET ב GITHUB ACTION ואחרי זה ביצעתי פקודת\
 echo "$GCP_SECRET" > .$pwd/$d/gke.json \
  שיוצרת לי קובץ עם ה CREDENTIALS שנדרשים\
ואז הרצתי את TERRAFORM בצורה הבאה \
terraform -chdir=.$pwd/$d ${{ inputs.tfcmd }}; \
ה INPUT בקובץ רץ בצורה ידנית ויהיה לנו אופציות לבחור את הפקודה שנכניס ל INPUT בשעת ההרצה וזה יראה כך 

![הרצת PIPLINE שלנו ](https://github.com/danielbachar11/phtoes/blob/main/kan-9/input.JPG)        








