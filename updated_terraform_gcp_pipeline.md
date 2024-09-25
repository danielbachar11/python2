
# הרצת TERRAFORM לפריסה של VM ו-BUCKET ב-GCP באמצעות GITHUB ACTION

## פירוט המשימה
הרצת מכונה וירטואלית ו-bucket ב-GCP.

## שלבים

- **שלב ראשון**: יצירת תיקיות עבור ה-Resources שלנו.
- **שלב שני**: יצירת קבצי הגדרות של `TERRAFORM`.
- **שלב שלישי**: יצירת קובץ Pipeline.

## דרישות מקדימות
- יש להתקין `TERRAFORM` ב-Runner שלנו.

## שלבים

### שלב ראשון: יצירת תיקיות למשאבים שלנו
ניצור את התיקיות הבאות:
```
mock_devops_tasks/terraform/us-central1/bucket  
mock_devops_tasks/terraform/us-central1/vm
```

### שלב שני: יצירת קבצי הגדרות של `TERRAFORM`

ניצור את הקבצים הבאים בתוך כל תיקייה:
1. קובץ ראשון שמכיל את פירוט המשאבים שלנו בשם `terraform.tf`.
2. קובץ שמכיל את פרטי ספק הענן בשם `provider.tf`.
3. קובץ משתנים בשם `variables.tf`.
4. קובץ `output.tf` שמציג את המשאבים שנוצרו.

### שלב שלישי: יצירת קובץ Pipeline
ניצור Pipeline עם קלט (Input) שיאפשר הרצת הפקודות `PLAN`, `APPLY`, ו-`DESTROY` למשאבים שלנו.

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
    runs-on: [self-hosted, Linux, X64]
    steps:
      - name: Check out the repository
        uses: actions/checkout@v4
        
      - name: Apply resources to Google Cloud using Terraform
        env:
          GCP_SECRET: ${{ secrets.GCP_SECRET }}
        run: | 
          for d in $(find terraform -type d -maxdepth 2 -path "terraform/*/*"); do
            echo "$GCP_SECRET" > .$pwd/$d/gke.json
            echo "Running on .$pwd/$d"
            terraform -chdir=.$pwd/$d init
            terraform -chdir=.$pwd/$d ${{ inputs.tfcmd }};
          done
```

### הסבר
כיוון שיש לנו שתי תיקיות תחת תיקיית `TERRAFORM`, נצטרך לבצע `FOR LOOP` שמחפש את תיקיות ה-TERRAFORM שלנו ומריץ עליהן פקודות `TERRAFORM`.

בשביל להכניס את ה-Credentials של GCP, יצרתי `SERVICE ACCOUNT` ונתתי לו את ההרשאות המתאימות. לאחר מכן יצרתי `SECRET` ב-GITHUB ACTION וביצעתי את הפקודה:
```bash
echo "$GCP_SECRET" > .$pwd/$d/gke.json
```
מה שיוצר קובץ עם ה-Credentials הנדרשים.

לאחר מכן הרצתי את `TERRAFORM` בצורה הבאה:
```bash
terraform -chdir=.$pwd/$d ${{ inputs.tfcmd }};
```

הקלט (`Input`) בקובץ רץ בצורה ידנית ומאפשר לבחור את הפקודה בשעת ההרצה. זה ייראה כך:

![הרצת Pipeline שלנו](https://github.com/danielbachar11/phtoes/blob/main/kan-9/input.JPG)
