# 🎯 LearnStreak: Your Daily Learning Habit Builder

**LearnStreak** is a **SwiftUI** application designed to help users build and maintain **consistent daily learning habits** using streak tracking and an innovative "Freeze" mechanic.

---

## ✨ Features

* **Goal & Duration Setting:** Define what you want to learn (your **Goal**) and commit to a specific duration (**Week, Month, or Year**).
* **Daily Check-in:** Press **"Learned Today"** to continue your learning streak for the current day.
* **Streak Freeze:** Use a **"Freeze"** to skip a day without breaking your streak. The number of available freezes is determined by your commitment duration:
    * **Week:** 2 Freezes
    * **Month:** 8 Freezes
    * **Year:** 9 Freezes
* **Calendar View:** Displays a **history of all past days** learned, missed, or frozen for clear progress visualization.
* **Goal Management:** Users can update the Goal or Duration, but note that this action will **reset the current streak** to maintain commitment integrity.

---

## 🖼️ App Screenshots

<div align="center">
  <img src="https://github.com/user-attachments/assets/930cd088-4c7d-463b-8a55-2a245c0c0946" width="30%" alt="Goal Setting Screen" />
  <img src="https://github.com/user-attachments/assets/74692cb7-a7ef-4a39-812b-b34e4457ce3f" width="30%" alt="Streak Activity and Calendar View" />
  <img src="https://github.com/user-attachments/assets/1ae6a481-4afd-4a00-8e8c-8db7f3ce3549" width="30%" alt="Duration Selection Screen" />
</div>

---

## 🛠️ Tech Stack & Architecture

* **Framework:** **SwiftUI**
* **Language:** Swift
* **Architecture:** **MVVM** (Model-View-ViewModel) for clean separation of UI and business logic.

---

## 💻 Setup

1.  **Clone the repository:**
    ```bash
    git clone [your-repository-url]
    ```
2.  **Open the project** in Xcode.
3.  **Run** on an iOS 16.0+ simulator or device (**Cmd + R**).

---

## 🚧 Current Status & Roadmap

* **Current Status:** The **entire UI is complete** and ready for the implementation of core logic.
* **Next Steps:** Focus on implementing the streak calculation, data persistence (for goals and history), and freeze management logic within the ViewModels.
