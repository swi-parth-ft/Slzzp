# Slzzp

Created by Parth Antala on 2024-07-06

## Overview
Slzzp is an iOS application developed using SwiftUI and CoreML that helps users determine their ideal bedtime based on their desired amount of sleep, wake-up time, and daily coffee intake.

## Features
- Customizable wake-up time using a date picker.
- Adjustable sleep amount with a slider.
- Coffee intake management with a stepper and buttons.
- Real-time bedtime calculation using CoreML.

## Screenshots
Include some screenshots here to give a visual overview of the app.

## Getting Started

### Prerequisites
- Xcode 12 or later
- iOS 14 or later

### Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/slzzp.git
    ```
2. Open the project in Xcode:
    ```bash
    cd slzzp && open Slzzp.xcodeproj
    ```
3. Build and run the project on your preferred simulator or device.

## Usage
1. Launch the app to start setting up your sleep preferences.
2. Select your desired wake-up time using the date picker.
3. Adjust the amount of sleep you want using the slider.
4. Set your daily coffee intake using the buttons.
5. Tap "Calculate" to see your ideal bedtime.

## Code Overview

### Main Components
- `ContentView.swift`: The main view of the app, handling the user interface and CoreML model integration.

### Key Functions
- `calculateBedtime()`: Uses a CoreML model to predict the ideal bedtime based on the user's input.
- `defaultWakeTime`: A static property that sets the default wake-up time to 7:00 AM.
- `ButtonViewModifier`: A custom view modifier for styling buttons.

### Dependencies
- `SwiftUI`: For building the user interface.
- `CoreML`: For machine learning model integration.
- `Sliders`: A custom slider library for SwiftUI.
