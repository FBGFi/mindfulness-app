# Mindfulness App

Track and take notes of ones feelings when they arise.

## App structure

App consists of multiple pages with different functionalities helping to track and analyze ones mindset over different periods of time, roughly separating different subsets of feelings into different categories.

- Front page
  - includes list of emotions tracked through current day
  - option to add new emotion to the list
    - opens a modal for selecting your current feeling and adding notes
- Calendar
  - shows notes and rough rank about ones feelings for each calendar day
  - allows selecting specific day to review how one was feeling during that day
- Analytics
  - can choose a time period from which to visualize feelings as heatmap or trend

## Notes

Using Hive required saved values to have declared models, which can be built into adapters by running `flutter packages pub run build_runner build`. This creates a \*.g.dart file containing the adapted which must then be registered in `main()`.

Note that saving lists directly to Hive must have their boxed type defined as dynamic. Fetched value from box can then be cast into correct type.
