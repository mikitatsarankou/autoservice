const { jestConfig } = require("@salesforce/sfdx-lwc-jest/config");
const testSuitPath = 'jest-mocks/';
module.exports = {
    ...jestConfig,
    reporters: [
        "default",
        [
            "jest-junit",
            {
                outputDirectory: "e2e/test-management-plugin/test_reports/lwc",
                outputName: "lwc-jest-junit.xml"
            }
        ]
    ],
    moduleNameMapper: {
        "^@salesforce/apex$": `<rootDir>${testSuitPath}apex`,
        "^@salesforce/schema$": `<rootDir>${testSuitPath}schema`,
        "^lightning/navigation$": `<rootDir>${testSuitPath}lightning/navigation`,
        "^lightning/platformShowToastEvent$": `<rootDir>${testSuitPath}lightning/platformShowToastEvent`,
        "^lightning/uiRecordApi$": `<rootDir>${testSuitPath}lightning/uiRecordApi`,
        "^lightning/messageService$": `<rootDir>${testSuitPath}lightning/messageService`,
        "^lightning/actions$": `<rootDir>${testSuitPath}lightning/action`
    },
    testTimeout: 10000
};
