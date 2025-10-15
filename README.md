# MovieQuiz - Квиз о фильмах

![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?logo=swift)
![iOS](https://img.shields.io/badge/iOS-15.0+-lightgrey?logo=apple)
![API](https://img.shields.io/badge/API-IMDb-F5C518?logo=imdb)
![Architecture](https://img.shields.io/badge/Architecture-MVC-blue)
![UIKit](https://img.shields.io/badge/UI-UIControl-2396F3?logo=apple)

**MovieQuiz** - увлекательное iOS-приложение с квизами о фильмах из топ-250 рейтинга и самых популярных фильмов по версии IMDb. Проверь свои знания о кинематографе и улучши результат с каждым раундом!

<p align="center">
  <img src="https://github.com/Brabus098/MovieQuiz/blob/main/error.png?raw=true" width="200" alt="Экран ошибки">
  <img src="https://github.com/Brabus098/MovieQuiz/blob/main/results.png?raw=true" width="200" alt="Результаты игры">
  <img src="https://github.com/Brabus098/MovieQuiz/blob/main/main-screen.png?raw=true" width="200" alt="Главный экран">
</p>

## 🎮 Возможности

### 🎯 Игровой процесс
- **10 вопросов в раунде** о рейтингах фильмов IMDb
- **Интуитивный интерфейс** с вариантами ответов "Да" и "Нет"
- **Визуальная обратная связь** - подсветка правильных/неправильных ответов
- **Автоматический переход** к следующему вопросу через 1 секунду

### 📊 Статистика и прогресс
- **Результаты раунда** - количество правильных ответов из 10
- **История игры** - количество сыгранных квизов
- **Рекорды** - лучший результат с датой и временем
- **Средняя точность** - процент правильных ответов за все время

### 🌐 Работа с данными
- **Актуальные данные** из IMDb API
- **Офлайн-режим** с обработкой ошибок сети
- **Локализованный контент** на русском языке

## 🛠 Технологический стек

**Языки программирования:**  
![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)

**iOS Frameworks:**  
![UIKit](https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=apple&logoColor=white)
![URLSession](https://img.shields.io/badge/Network-URLSession-1E8CBE?style=for-the-badge&logo=apple)

**Tools & Platforms:**  
![Xcode](https://img.shields.io/badge/Xcode-1575F9?style=for-the-badge&logo=xcode&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

**Architecture & Methods:**  
![MVC](https://img.shields.io/badge/Architecture-MVC-FA7343?style=for-the-badge)

## ⚙️ Установка и запуск

### Требования
- macOS 13.0+
- Xcode 14.0+
- iOS 15.0+

### Быстрый старт

```bash
git clone https://github.com/Brabus098/MovieQuiz.git
cd MovieQuiz
open MovieQuiz.xcodeproj
```

1. Выберите симулятор или подключите устройство
2. Нажмите Cmd + R для сборки и запуска
3. Начните играть - отвечайте на вопросы о рейтингах фильмов

## 🏗 Архитектура

Проект реализован с использованием MVC архитектуры:
- Четкое разделение логики, данных и интерфейса
- Простота поддержки - минимальное количество зависимостей
- Эффективная работа с сетью и пользовательским интерфейсом

## 🎯 Особенности реализации
Работа с сетью
Асинхронная загрузка данных через URLSession
Обработка ошибок сети с пользовательскими алертами
Кэширование изображений для плавного UX

## 🎮 Игровая логика
Генерация случайных вопросов о рейтингах фильмов
Система подсчета очков и ведения статистики

Таймеры для автоматических переходов между вопросами

## 🎨 Пользовательский интерфейс
Полное соответствие макету Figma

Адаптивная верстка под iPhone (X и новее)

Анимации переходов и обратной связи

## 📈 Статус разработки
✅ Завершено: Базовый игровой процесс с 10 вопросами

✅ Завершено: Интеграция с IMDb API

✅ Завершено: Система статистики и рекордов

✅ Завершено: Обработка ошибок сети

✅ Завершено: Полное соответствие макету Figma

🔄 В планах: Дополнительные режимы игры

🔄 В планах: Социальные функции (лидерборды)

## 👨‍💻 Автор
Vladimir - iOS Developer

<p align="center"> <a href="https://t.me/Vov4eg777"> <img src="https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white&color=FA7343" alt="Telegram"/> </a> <a href="mailto:olsh0988@gmail.com"> <img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white&color=FA7343" alt="Email"/> </a> <a href="https://docs.google.com/document/d/18caT1lR7wfQcId3kl3MaWkGpnjQqEGYBz7goR_59zEw/edit?usp=sharing"> <img src="https://img.shields.io/badge/Resume-4285F4?style=for-the-badge&logo=google-drive&logoColor=white&color=FA7343" alt="Resume"/> </a> </p>
