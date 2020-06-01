Feature: Callbacks can access and modify event information

Scenario: Removing an OnSend callback does not affect other OnSend callbacks
    When I run "OnSendCallbackRemovalScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "metaData.callbacks.config" is null
    And the event "metaData.callbacks.config2" equals "adding metadata"

Scenario: An OnErrorCallback can overwrite information for a handled error
    When I run "OnErrorOverwriteScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "app.id" equals "customAppId"
    And the event "context" equals "customContext"
    And the event "device.id" equals "customDeviceId"
    And the event "groupingHash" equals "customGroupingHash"
    And the event "severity" equals "info"
    And the event "user.id" equals "customId"
    And the event "user.email" equals "customEmail"
    And the event "user.name" equals "customName"

Scenario: An OnSend callback can overwrite information for an unhandled error
    When I run "SwiftAssertion" and relaunch the app
    And I configure Bugsnag for "OnSendOverwriteScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "app.id" equals "customAppId"
    And the event "context" equals "customContext"
    And the event "device.id" equals "customDeviceId"
    And the event "groupingHash" equals "customGroupingHash"
    And the event "severity" equals "info"
    And the event "user.id" equals "customId"
    And the event "user.email" equals "customEmail"
    And the event "user.name" equals "customName"

Scenario: Information set in OnCrashHandler is added to the final report
    When I run "OnCrashHandlerScenario" and relaunch the app
    And I configure Bugsnag for "OnSendOverwriteScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "metaData.custom.strVal" equals "customStrValue"
    And the event "metaData.custom.boolVal" is true
    And the event "metaData.custom.intVal" equals 5
    And the event "metaData.complex.objVal.foo" equals "bar"
    And the event "metaData.custom.doubleVal" is not null
    And the event "metaData.complex.arrayVal" is not null

Scenario: The original error property is populated for a handled NSError
    When I run "OriginalErrorNSErrorScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "metaData.custom.hasOriginalError" is true

Scenario: The original error property is populated for a handled NSException
    When I run "OriginalErrorNSExceptionScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "metaData.custom.hasOriginalError" is true

Scenario: OnSend callbacks run in the order in which they were added
    When I run "OnSendCallbackOrderScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "metaData.callbacks.notify" equals 0
    And the event "metaData.callbacks.config" equals 1
    And the event "metaData.callbacks.client" equals 2
    And the event "metaData.callbacks.secondClient" equals 3