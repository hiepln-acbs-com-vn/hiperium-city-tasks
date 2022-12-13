# Tasks Service: An Ionic/Angular PWA with Amplify and NgRx for reactive programming.
## Required Tools
- sudo npm install -g @angular/cli
- sudo npm install -g @ionic/cli
- sudo npm install -g http-server
- sudo npm install -g @aws-amplify/cli

## Updating Angular dependencies
Verify the angular versions that can be updated inside the project:
```
ng update
```
Try to edit the corresponding packages showed in the last command output. For example:
```
ng update @angular/cli @angular/core @ngrx/store --allow-dirty --force
```
And those Angular dependencies will be updated.

## Adding Amplify dependencies
Install the Amplify dependency:
```bash
npm install --save aws-amplify
```
We are not installing the `@aws-amplify/ui-angular` package because we're not using any Amplify UI component like the Authentication.


## Adding OAuth2 dependencies
Install the OAuth2 dependencies:
```bash
npm install angular-oauth2-oidc
```

## Adding Angular Reactive (NgRx) dependencies
For NgRx, we need to install the following dependencies:
```
ng add @ngrx/data
ng add @ngrx/store
ng add @ngrx/effects
ng add @ngrx/router-store
ng add @ngrx/store-devtools
```
These commands edit the "app.module.ts" file with the required imports and initial configurations. See the blog article fo more details.

## Adding the Animate CSS
[Animate.css](https://animate.style/) is a library of ready-to-use, cross-browser animations for use in your web projects.
```
npm install animate.css --save
```
Modify the "global.scss" file to add the following code:
```
@import "~animate.css/animate.min.css";
```

## Ionic DateTime
For this component, we must install the "date-fns" and "date-fn-tz" dependency for datetime validation and manipulation:
```
npm install date-fns --save
npm install date-fns-tz --save
```

## Other Ionic important commands
To create a new ionic project using a blank template;
```
ionic start <project-name> blank --type=angular
```
To create a new angular **module** with a routing file;
```
ionic g module shared/components --routing
```
To create a new **component** (not include a module and routing file):
```
ionic g component shared/components/header --spec=false
```
To create a new **page** component without the spec file:
```
ionic g page shared/pages/home --spec=false
```
If you want to only visualize the files that will be created, add the dry-run directive:
```
ionic g page shared/pages/home --spec=false --dry-run
```
To create a new angular **service** without the test file, you can execute the following:
```
ionic g service shared/services/storage --skipTests
```
