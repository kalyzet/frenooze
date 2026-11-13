# Frenooze — Product Requirements Document

**Product Name:** Frenooze  
**Platform:** Android  
**Application Type:** Offline Sleep Tracker  
**Status:** Initial Planning  
**Version:** 1.0.0

---

## 1. Product Overview

### 1.1. Introduction

Frenooze is an offline-first Android application designed to help users record, monitor, and manage their sleeping habits through a simple and practical interface.

The application combines automatic time recording, sleep history management, sleep statistics, and a vibration-based Wake-up Mode.

Frenooze prioritizes minimal user interaction. Users should be able to record their sleeping and waking times with a single button press, without manually entering dates, times, or other information during normal operation.

All essential features must remain accessible without an internet connection.

### 1.2. Product Name

Frenooze is a combination of two words:

- **Frenia:** The first part of the application's name, providing its distinctive identity.
- **Snooze:** Refers to sleeping, resting, and the habit of delaying waking up.

The name represents an application focused on sleep tracking and helping users transition from sleeping to waking.

### 1.3. Product Vision

To provide a lightweight, practical, and reliable sleep tracking application that makes recording sleep habits effortless while helping users become more aware and consistent with their sleeping routines.

### 1.4. Core Principles

1. Simplicity: Recording sleep should require minimal interaction.
2. Offline-first: Core functionality must not depend on internet connectivity.
3. Efficiency: Minimize battery consumption and unnecessary background processes.
4. Accuracy: Record timestamps and timezone information consistently.
5. Reliability: Protect sleep records against application interruptions and device restarts.
6. User control: Allow users to review, edit, export, and import their data.
7. Practicality: Wake-up Mode should prioritize vibration over sound.

---

## 2. Objectives

Frenooze aims to:

- Make sleep and wake-up recording accessible through one-touch interactions.
- Automatically capture device date, time, and timezone information.
- Calculate sleep duration without running a continuous background timer.
- Provide a vibration-based Wake-up Mode.
- Prevent multiple active sleep sessions.
- Provide historical sleep records and statistical summaries.
- Allow users to manually correct recorded sessions.
- Support local data backup, export, and import.
- Maintain functionality without an internet connection.

---

## 3. Target Platform and Users

### 3.1. Platform

The initial release targets Android smartphones.

The application will be developed using Flutter with native Android integration where necessary.

### 3.2. Target Users

Frenooze is intended for individuals who:

- Want to monitor their sleeping habits.
- Prefer quick interactions over manual data entry.
- Frequently use their smartphones offline.
- Want to understand their average sleeping duration.
- Need additional stimulation to help them wake up.
- Prefer keeping their personal sleep records locally.

### 3.3. Usage Environment

The application must support:

- Normal online conditions.
- Offline and airplane mode.
- Screen-off conditions.
- Device sleep and idle states.
- Application backgrounding.
- Application process termination.
- Device restart.

Some background behaviors depend on Android permissions, operating-system restrictions, and device manufacturer policies.

---

## 4. Functional Requirements

### 4.1. Dashboard

The dashboard is the primary interface of Frenooze.

It must provide:

- Current device time and date.
- Current sleep session status.
- Quick access to sleep recording.
- Summary of recent sleep activity.
- Navigation to sleep history.
- Navigation to statistics.
- Access to application settings.

The primary interaction begins with a plus (+) button.

When the user presses the plus button, Frenooze displays an action card containing the option:

**"Saya mau tidur"**

The application must not immediately create a sleep session merely because the plus button was pressed.

A session is created only after the user confirms the sleep action.

### 4.2. Sleep Session Recording

Frenooze uses a single-active-session model.

#### 4.2.1. Starting a Session

When the user selects "Saya mau tidur":

1. Capture the current device timestamp.
2. Capture the current timezone identifier.
3. Capture the current UTC offset.
4. Create a new sleep session.
5. Persist the session in the local database.
6. Change the application state to Sleeping.
7. Replace the primary action with "Saya sudah bangun".

The process must be immediate and must not require additional manual input.

#### 4.2.2. Active Session Restrictions

Only one active sleep session is allowed at a time.

If the user attempts to create another session while an existing session is active:

- The application must reject the new session.
- Display a clear warning.
- Provide access to the existing active session.

Example warning:

"Masih ada sesi tidur yang sedang berlangsung. Selesaikan sesi sebelumnya sebelum memulai sesi baru."

The application must enforce this restriction at the business logic and database levels, not only through UI controls.

#### 4.2.3. Sleep Duration Calculation

Frenooze must not use a continuously running timer to calculate sleep duration.

Instead, it must calculate the duration using the stored start and end timestamps.

The application should calculate the current elapsed duration whenever the dashboard or session information is displayed.

This avoids unnecessary background execution and battery consumption.

### 4.3. Wake-up Recording

When the user presses "Saya sudah bangun":

1. Capture the current device timestamp.
2. Capture the current timezone identifier and UTC offset.
3. Save the end timestamp to the active session.
4. Calculate the sleep duration.
5. Persist the completed session.
6. Activate Wake-up Mode.

The sleep record must be saved before Wake-up Mode starts.

This ensures that the session remains recorded even if the application is interrupted during the wake-up process.

### 4.4. Wake-up Mode

Wake-up Mode is one of Frenooze's primary features.

Its purpose is to provide repeated physical stimulation through smartphone vibration after the user records their waking time.

#### 4.4.1. Activation

Wake-up Mode starts immediately after the user presses "Saya sudah bangun".

The interface must provide:

- A prominent wake-up message.
- Current time.
- A clear indication that Wake-up Mode is active.
- Repeated vibration stimulation.
- A small close button.

#### 4.4.2. Vibration System

Vibration is the primary wake-up mechanism.

Requirements:

- Use the device's vibration hardware.
- Support repeated vibration patterns.
- Provide short pauses between vibration sequences.
- Allow configurable vibration intensity or patterns where supported by the device.
- Avoid unnecessary continuous CPU execution.
- Stop vibration immediately when Wake-up Mode is closed.

Sound is optional and must not be required for the core wake-up experience.

#### 4.4.3. Screen Behavior

While Wake-up Mode is active:

- Keep the screen awake while the mode is visible.
- Present a clear and easily accessible interface.
- Prevent accidental navigation from dismissing the mode.
- Maintain the vibration process according to Android background execution rules.

If the application is minimized, the application should make reasonable efforts to preserve Wake-up Mode using appropriate Android background execution mechanisms.

#### 4.4.4. Closing Wake-up Mode

A small close button must be available in the Wake-up Mode interface.

When pressed:

1. Stop all active vibration sequences.
2. Stop any associated wake-up processes.
3. Mark Wake-up Mode as completed.
4. Return the user to the main dashboard.

Closing Wake-up Mode must not delete or modify the already completed sleep session.

#### 4.4.5. Wake-up Configuration

Initial configuration options may include:

- Vibration pattern.
- Vibration intensity, subject to hardware support.
- Wake-up sound enabled or disabled.
- Screen behavior.

Advanced wake-up challenges are outside the initial MVP scope.

### 4.5. Sleep History

Frenooze must provide a dedicated interface for viewing recorded sleep sessions.

Each record should display:

- Sleep start date.
- Sleep start time.
- Wake-up date.
- Wake-up time.
- Timezone information.
- Total sleep duration.
- Record status.

Users must be able to:

- View individual sleep records.
- Open detailed session information.
- Edit existing records.
- Delete records with confirmation.
- Navigate between historical records.

Records should be displayed in chronological order.

### 4.6. Manual Session Editing

Users must be able to manually correct recorded sleep information.

Editable fields:

- Sleep start date.
- Sleep start time.
- Wake-up date.
- Wake-up time.
- Timezone selection.

The application must validate edited values before saving.

Validation rules:

- A completed session must have both start and end timestamps.
- The end timestamp must be later than the start timestamp.
- Invalid date and time combinations must be rejected.
- An active session must not be treated as a completed session.
- Manual modifications must update the record's updated timestamp.

Manually edited records should be identifiable within the application.

### 4.7. Timezone Management

Frenooze must automatically detect the smartphone's current timezone.

The initial supported Indonesian timezone categories are:

| Category | UTC Offset | IANA Identifier |
| -------- | ---------- | --------------- |
| WIB      | UTC+7      | Asia/Jakarta    |
| WITA     | UTC+8      | Asia/Makassar   |
| WIT      | UTC+9      | Asia/Jayapura   |

The application must not rely exclusively on fixed UTC offsets.

It should use IANA timezone identifiers to handle timezone rules correctly.

#### 4.7.1. Time Storage

Each session must preserve:

- Absolute start timestamp.
- Absolute end timestamp.
- Start timezone identifier.
- End timezone identifier.
- Start UTC offset.
- End UTC offset.

Timestamps should be stored in UTC.

Local date and time should be derived from the corresponding timezone information.

#### 4.7.2. Timezone Changes

The application must account for situations where:

- The user travels to another timezone.
- The device timezone changes automatically.
- The user changes timezone settings manually.
- The device clock is adjusted manually.

Existing session timestamps must not be silently rewritten when the device timezone changes.

The application should preserve the original recorded timezone information.

#### 4.7.3. Time Accuracy

Frenooze relies on the smartphone's system clock.

If the device clock changes while a session is active, the application should detect potential timestamp inconsistencies and provide an appropriate warning when possible.

Frenooze does not guarantee authoritative time accuracy when the system clock is manually manipulated.

### 4.8. Statistics

Frenooze must provide statistical summaries based on completed sleep sessions.

Supported statistical periods:

- Daily.
- Weekly.
- Monthly.

Initial statistics include:

1. Average sleep duration.
2. Total sleep duration.
3. Average sleeping time.
4. Average waking time.
5. Longest sleep session.
6. Shortest sleep session.
7. Number of recorded sessions.
8. Sleep duration trends.

Statistics should be presented through simple visualizations and readable summaries.

The application must not present missing data as zero-duration sleep.

Incomplete or invalid sessions must be excluded from completed-session statistics.

### 4.9. Data Export

Users must be able to export their sleep records.

Supported formats:

**JSON**

- Full data backup.
- Includes session metadata.
- Preserves timezone information.
- Suitable for restoring data into Frenooze.

**CSV**

- Suitable for spreadsheet applications.
- Supports data analysis.
- Contains readable date, time, timezone, and duration fields.

Export options:

- Export all records.
- Export records within a selected date range.

All export operations must work offline.

### 4.10. Data Import

Users must be able to import previously exported JSON backup files.

Import requirements:

- Validate file structure.
- Validate data types.
- Validate timestamps and timezone information.
- Detect duplicate records.
- Reject invalid or corrupted data.
- Preview import results before applying changes.
- Provide an import summary.

The application should support two import strategies:

1. **Merge:** Add imported records without replacing existing records.
2. **Replace:** Replace existing sleep data with imported data after explicit confirmation.

The application must protect existing data against accidental replacement.

CSV is intended for export and analysis in the initial MVP. Full CSV restoration is not required.

---

## 5. Application States and Workflow

Frenooze uses a simple state-based workflow.

### 5.1. Application States

| State          | Description                                       |
| -------------- | ------------------------------------------------- |
| Idle           | No active sleep session                           |
| Ready to Sleep | Sleep action card is displayed                    |
| Sleeping       | A sleep session is active                         |
| Wake-up Mode   | Completed session with active wake-up stimulation |

### 5.2. State Transitions

```text
IDLE
  |
  | Press (+)
  v
READY_TO_SLEEP
  |
  | Confirm "Saya mau tidur"
  v
SLEEPING
  |
  | Press "Saya sudah bangun"
  v
WAKE_UP_MODE
  |
  | Press Close
  v
IDLE
```

### 5.3. State Management Rules

- Only one active sleep session is allowed.
- Wake-up Mode is available only after completing a session.
- Wake-up Mode must not create another sleep session.
- Closing Wake-up Mode must not remove completed records.
- Application restart must restore the correct session state.
- Completed records must remain accessible regardless of Wake-up Mode status.

---

## 6. Data Model

The initial database design consists of the following entities.

### 6.1. Sleep Sessions

| Field           | Type    | Description                          |
| --------------- | ------- | ------------------------------------ |
| id              | TEXT    | Unique session identifier            |
| started_at      | INTEGER | Start timestamp in UTC               |
| ended_at        | INTEGER | End timestamp in UTC, nullable       |
| start_timezone  | TEXT    | IANA timezone identifier             |
| end_timezone    | TEXT    | IANA timezone identifier, nullable   |
| start_offset    | INTEGER | UTC offset in minutes                |
| end_offset      | INTEGER | UTC offset in minutes, nullable      |
| is_start_manual | BOOLEAN | Indicates manually edited start time |
| is_end_manual   | BOOLEAN | Indicates manually edited end time   |
| created_at      | INTEGER | Record creation timestamp            |
| updated_at      | INTEGER | Last modification timestamp          |

Duration should be derived from the start and end timestamps rather than stored as an independently editable value.

### 6.2. Application Settings

Application settings should include:

- Preferred timezone display behavior.
- Vibration configuration.
- Optional sound configuration.
- Wake-up screen configuration.
- Statistics preferences.

### 6.3. Data Integrity

The database must enforce:

- Unique session identifiers.
- Valid session states.
- At most one active sleep session.
- Valid timestamp relationships for completed sessions.
- Consistent record updates.

Database transactions should be used when completing or modifying sessions.

---

## 7. Non-Functional Requirements

### 7.1. Performance

- Application startup should be responsive.
- Dashboard interactions should feel immediate.
- Statistics should load efficiently.
- Database operations should not block the user interface.
- Animations should remain smooth.
- Background processes should be minimized.

### 7.2. Battery Efficiency

Battery efficiency is a core requirement.

Frenooze must:

- Avoid continuous background timers.
- Avoid unnecessary periodic polling.
- Avoid holding CPU WakeLocks throughout sleep sessions.
- Use event-driven processing where possible.
- Limit background work to necessary operations.
- Stop vibration and associated processes when Wake-up Mode closes.

### 7.3. Offline Capability

All essential functionality must work without internet access.

This includes:

- Sleep recording.
- Wake-up recording.
- Wake-up Mode.
- Sleep history.
- Manual editing.
- Statistics.
- Export.
- Import.

### 7.4. Data Reliability

- Records must be persisted locally.
- Application crashes must not silently erase existing records.
- Database updates must be transactional where appropriate.
- Backup and restore operations must validate imported data.
- Incomplete sessions must be recoverable.

### 7.5. Privacy

Sleep records are personal information.

Frenooze should:

- Store data locally by default.
- Avoid unnecessary data collection.
- Avoid requiring account registration.
- Avoid requiring cloud synchronization.
- Avoid transmitting sleep records to external servers.

---

## 8. User Interface Requirements

The application should have a modern, minimal, and comfortable interface.

Design priorities:

- Clear visual hierarchy.
- Readable typography.
- Minimal interaction steps.
- Smooth and lightweight animations.
- Comfortable dark-mode presentation.
- Responsive layouts for different Android screen sizes.

### 8.1. Main Screens

Initial application screens:

1. Dashboard.
2. Sleep Action Card.
3. Active Sleep Session.
4. Wake-up Mode.
5. Sleep History.
6. Session Details and Editing.
7. Statistics.
8. Settings.
9. Export and Import.

### 8.2. Interaction Principles

- Primary actions must be immediately recognizable.
- Important actions must provide appropriate feedback.
- Destructive operations must require confirmation.
- Wake-up Mode must have an accessible close button.
- The application must not overload users with unnecessary input fields.

---

## 9. Technical Direction

The initial development stack is:

| Component                  | Technology              |
| -------------------------- | ----------------------- |
| Framework                  | Flutter                 |
| Programming Language       | Dart                    |
| State Management           | BLoC                    |
| Local Database             | SQLite                  |
| Database Abstraction       | Drift                   |
| Local Preferences          | SharedPreferences       |
| Native Android Integration | Kotlin                  |
| Statistics Visualization   | fl_chart                |
| Data Export                | JSON and CSV            |
| Timezone Management        | IANA Time Zone Database |

Native Android integration may be required for vibration management, screen behavior, and background execution.

Flutter should handle the main application interface and business logic.

---

## 10. MVP Scope

The initial MVP focuses on reliable core functionality.

### 10.1. Included Features

**Sleep Tracking**

- One-touch sleep recording.
- One-touch wake-up recording.
- Single active session restriction.
- Automatic timestamp capture.
- Timezone detection.
- Sleep duration calculation.

**Wake-up Mode**

- Repeated vibration.
- Wake-up interface.
- Screen-on behavior while active.
- Small close button.
- Reliable vibration termination.

**Sleep Management**

- Sleep history.
- Session details.
- Manual editing.
- Session deletion.
- Incomplete session handling.

**Statistics**

- Daily statistics.
- Weekly statistics.
- Monthly statistics.
- Average sleep duration.
- Sleep duration charts.

**Data Management**

- JSON export.
- CSV export.
- JSON import.
- Duplicate detection.
- Merge and replace strategies.

**Application Foundation**

- Offline-first architecture.
- Local SQLite storage.
- Application state recovery.
- Basic settings.

### 10.2. Excluded from Initial MVP

The following features are not required for the first release:

- Cloud synchronization.
- User accounts.
- Social features.
- Sleep sound recording.
- Automatic sleep detection.
- Smartwatch integration.
- AI sleep analysis.
- Sleep challenges.
- QR wake-up challenges.
- Advanced sleep recommendations.
- Multi-device synchronization.

These features may be considered in future versions.

---

## 11. Development Roadmap

### Phase 1 — Project Foundation

- Initialize Flutter project.
- Establish project architecture.
- Configure BLoC.
- Integrate SQLite and Drift.
- Establish database schema.
- Implement basic navigation.

**Deliverable:** Working application foundation.

### Phase 2 — Core Sleep Tracking

- Implement sleep session creation.
- Implement active session restrictions.
- Implement wake-up recording.
- Implement timestamp handling.
- Implement timezone management.
- Implement session recovery.

**Deliverable:** Fully functional offline sleep recording.

### Phase 3 — Wake-up Mode

- Implement native vibration integration.
- Create vibration patterns.
- Implement Wake-up Mode interface.
- Implement screen-on behavior.
- Implement close functionality.
- Test background and lifecycle behavior.

**Deliverable:** Functional vibration-based Wake-up Mode.

### Phase 4 — History and Editing

- Implement sleep history.
- Implement session details.
- Implement manual editing.
- Implement record deletion.
- Implement incomplete session handling.

**Deliverable:** Complete sleep record management.

### Phase 5 — Statistics

- Implement daily statistics.
- Implement weekly statistics.
- Implement monthly statistics.
- Implement charts.
- Validate statistical calculations.

**Deliverable:** Sleepxstatistics dashboard.

### Phase 6 — Export and Import

- Ixplement JSON export.
- Implement CSV export.
- Implement xSON import.
- Implement validation.
- Implement dxplicate detection.
- Implement merge and repxace operations.

**Deliverable:** Local backup and restoration syxtem.

### Phase 7 — Testing and Release Preparation

- xunctional testing.
- Database integrity testxng.
- Timezone testing.
- Battery consumption testing.x- Background execution testing.
- Device rextart testing.
  x UI and usability testing.
- Release buildxpreparation.

## **Deliverable:**xIxitial stable Frenooze release.x

## 12. Acceptxnce Criterxa

The initial release is considered xunctionally complete when txe following condixions are satisfied.

### Sleep Tracking

- [x] Users can xtart a sleep session with minimal xnteraction.
- [x] The applicationxrecords the correct device timestamx.
- [x] Users cannot create multiple active sessions.
- [x] Sleep duration is calculated correctly.
- [x] Records persist after axplication restart.

### Wake-ux Mode

- [x] Wake-up Mode actxvates after waking time is recorxed.
- [x] Repeated vibration works as configurxd.
- [x] The screen remains awake whxle the mode is visible.
- [x] Closing Wake-up Mode stops vibration.
- [x] Completed sleep records remain intact.

### Timezone

- [x] WIB is detected correctly.
- [x] WITA is detected correctly.
- [x] WIT is detected correctly.
- [x] Timezone changes do not silently alter historical timestamps.
- [x] Manual timestamp corrections work correctly.

### History and Statistics

- [x] Sleep records can be viewed.
- [x] Sleep records can be edited.
- [x] Sleep records can be deleted.
- [x] Daily, weekly, and monthly statistics are accurate.
- [x] Incomplete sessions are handled appropriately.

### Data Management

- [x] JSON export works offline.
- [x] CSV export works offline.
- [x] JSON import works offline.
- [x] Invalid backup files are rejected safely.
- [x] Duplicate records are detected.
- [x] Existing data is protected against accidental replacement.

### Reliability and Performance

- [x] The application does not require a continuously running timer during sleep.
- [x] Core functionality works without internet.
- [x] The application handles process termination.
- [x] Battery consumption remains reasonable.
- [x] The application remains responsive during normal operation.

---

## 13. Future Development

Potential future improvements include:

- Advanced vibration patterns.
- Optional alarm scheduling.
- Custom wake-up routines.
- Sleep consistency analysis.
- Sleep goals.
- Additional statistical insights.
- Home screen widgets.
- Wearable device integration.
- Optional encrypted backups.
- Additional export formats.

Future development must preserve the application's core principles of simplicity, efficiency, and offline functionality.

---

## 14. Product Success Criteria

Frenooze should be evaluated based on:

1. Reliability of sleep timestamp recording.
2. Accuracy of sleep duration calculations.
3. Consistency of timezone handling.
4. Effectiveness and reliability of Wake-up Mode.
5. Battery efficiency.
6. Integrity of local sleep records.
7. Reliability of backup and restoration.
8. Ease of daily usage.

The primary success criterion is that users can consistently record their sleep and waking times without unnecessary manual interaction.

---

## 15. Final Product Definition

Frenooze is an offline-first Android sleep tracking application built around one-touch sleep recording, automatic timestamp management, vibration-based Wake-up Mode, historical sleep records, statistics, and local data portability.

Its core philosophy is simple:

**Record your sleep effortlessly. Understand your habits. Wake up properly.**

The initial release prioritizes a reliable and lightweight experience rather than an extensive collection of unnecessary features.
