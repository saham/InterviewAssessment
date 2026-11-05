# LabReport

Small iOS app with two tabs, Home and Report. The Report tab loads a FHIR R4 DiagnosticReport from https://build.fhir.org/diagnosticreport-example.json and shows the report name, test performer, date/time and the result of each observation.

## Environment
UIKit, Swift, Xcode 27.2, ran on iOS 26.6.

## Run

```
git clone https://github.com/saham/InterviewAssessment.git
cd InterviewAssessment
git checkout main
```

## Dependencies
None. The JSON is decoded with my own Codable structs in FHIRData.swift, then mapped to VitalObservationModel. The structs only cover the parts of FHIR R4 the screen needs.

## Structure

MVVM. NetworkService downloads and decodes the JSON. ReportViewModel finds the report and its observations and turns them into VitalObservationModel. The view controllers just show what the view model has. 
VitalObservationModel also builds the result and range text, so the cell only displays it.

```
App/          AppConstant, AppDelegate, SceneDelegate
Extensions/   Double+String, String+Date, UIImage,
              UILabel+RangeColor, UIViewController, ResultStatus+Color
Models/       FHIRData, VitalObservationModel
Network/      NetworkService, ReportError
ViewModels/   ReportViewModel
Views/        HomeViewController, LabSummaryViewController, ObservationCell,
              RecordsViewController, ReportDetailViewController, CardView
LabReportTests/   unit tests, fake network service, data.json
```

## Assumptions

- The response has one report. If there were more, only the last one is used.
To improve this, LabSummaryViewController could list multiple reports.
- Observations are matched to the report by id (Observation/r1). Missing ones are skipped.
- Test performer uses the first performer's display name. The data has one per report.
- effectiveDateTime is shown as recorded, no timezone conversion. An effectivePeriod is not decoded.
- Only numeric results (valueQuantity) are shown. Other value types are not decoded.
- Normal range uses the first reference range. The sample data has one range per observation
  - One boundary shows ≥ or ≤.
  - No boundary shows N/A.
- Current JSON has only 1 "referenceRange" hence the code uses the first referenceRange in an observation 
- Some tests appear twice (% and count). I assumed they are separate observations, and I kept both.
- Result coloring is an extra, not part of the requirements. It comes from the normal range, not the data's interpretation field.
-  Report tab has "Records" on the navigation bar and "Report" on the tab bar. This is to match specification.
- One flow only: Report tab  → Lab Summary → Report Detail, so the navigation bar styling carries over.

## Unit tests

They cover the view model, the in-range check, the result and range text, and the date/number helpers. NetworkService, the view controllers and other UI code are not unit tested. No UI tests.

## Screenshots

| Home | Report | Report Summary | Report Detail |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/ae859e0b-b496-4627-8a2a-9a12aab8d3ad" width="160" /> | <img src="https://github.com/user-attachments/assets/1b7a20c1-927f-4689-91a6-e28726620fc5" width="160" /> | <img src="https://github.com/user-attachments/assets/f72c9910-39c3-4120-8c64-d1faf97fbd55" width="160" /> | <img src="https://github.com/user-attachments/assets/828b7ca8-1d86-4de8-829f-5941070b39d1" width="160" /> |
