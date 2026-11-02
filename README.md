# LabReport

Small iOS app with two tabs, Home and Report. The Report tab loads a FHIR R4 DiagnosticReport from https://build.fhir.org/diagnosticreport-example.json and shows the report name, test performer, date/time and the result of each observation.

## Environment
UIKit, Swift, Xcode 27.2, ran on iOS 26.6.

## Run

```
git clone https://github.com/saham/InterviewAssessment.git
cd InterviewAssessment
git checkout feature/R4Model
```

## Dependencies
ModelsR4 from https://github.com/apple/FHIRModels.git (0.9.4) through SPM. I only used it to decode the JSON, then mapped it to my own VitalObservationModel.

## Structure

MVVM. NetworkService downloads and decodes the JSON. ReportViewModel finds the report and its observations and turns them into VitalObservationModel. The view controllers just show what the view model has. The network service is passed into the view model so tests can swap it.

```
App/          AppConstant, AppDelegate, SceneDelegate
Extensions/   Double+String, Quantity+Double, String+Date, UIImage,
              UILabel+RangeColor, UIViewController, ResultStatus+Color
Models/       VitalObservationModel
Network/      NetworkService, ReportError
ViewModels/   ReportViewModel
Views/        HomeViewController, LabSummaryViewController, ObservationCell,
              RecordsViewController, ReportDetailViewController
LabReportTests/   unit tests, fake network service, data.json
```

## Assumptions

- The response has one report. If there were more, only the last one is used.
- Observations are matched to the report by id (Observation/r1). Missing ones are skipped.
- Date is shown as recorded, no timezone conversion. Uses effectiveDateTime, or issued if that's missing.
- Only numeric results (valueQuantity) are shown.
- Normal range uses the first reference range. One boundary shows ≥ or ≤, no boundary shows N/A.
- Some tests appear twice (% and count). I assumed they are separate observations, and I kept both.
- Values are rounded to 6 decimals.
- I didn't use the interpretation field from the data. Color comes from the normal range.

## Unit tests

They cover the view model, the in-range check and the date/number helpers. No UI tests.
