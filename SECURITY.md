# Безбедност - Firebase конфигурација

## ⚠️ Важно за Git репозиториум

**`GoogleService-Info.plist` и `google-services.json` фајловите содржат чувствителни API клучеви и НЕ треба да се комитуваат во Git репозиториум!**

## Што е направено:

✅ Додадено во `.gitignore`:
- `**/GoogleService-Info.plist`
- `**/google-services.json`

## Што треба да направиш:

### 1. Отстрани го фајлот од Git историјата (ако веќе е комитуван):

```bash
# Отстрани го од Git tracking (но зачувај го локално)
git rm --cached ios/Runner/GoogleService-Info.plist

# Комituвај ја промената
git commit -m "Remove GoogleService-Info.plist from version control"
```

### 2. Ротирај ги API клучевите во Firebase Console:

1. Оди на [Firebase Console](https://console.firebase.google.com/)
2. Избери го проектот `lab2-meal-app`
3. Оди на Project Settings → General
4. Ротирај ги API клучевите (revoke старите и креирај нови)

### 3. За тим работа:

- Секoj член на тимот треба да го преземе `GoogleService-Info.plist` од Firebase Console
- Не го споделувај преку Git или email
- Користи Firebase Console за да го споделиш со тимот

## Забелешка:

Ова е нормално за Firebase проекти - конфигурациските фајлови треба да се чуваат приватно и да не се комитуваат во публични репозиториуми.

