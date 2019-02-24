# Github Actions

This repository contains some custom Github actions.

## 1. Label Pull Request

This action allows you to add specific labels when a PR is opened. Also, the action is connected to Jira in order to retrieve
the priority of the feature using the issue code added in the PR title.

### Usage:

```hcl
action "Label Pull Request" {
  uses = "xserrat/github-actions/action/label-pull-request@master"
  secrets = ["GITHUB_TOKEN", "JIRA_ENCODED_TOKEN", "URI_JIRA"]
  env = {
    REVIEWERS = "maintainer1,maintainer2"
    REGEXP_FOR_JIRA_CODE_ON_PR_TITLE = "^([A-Z]{4}-[0-9]{4}).*"
    LABELS_ON_PULL_REQUEST_OPENED = "needs feedback"
  }
}
```

#### Secrets:

To add any secret to Github you need to go to `https://github.com/{username}/{repository}/settings/secrets` and add a new one.

* `GITHUB_TOKEN`: It's a needed secret (THIS TOKEN IS FULFILLED AUTOMATICALLY, YOU DON'T HAVE TO ADD IT)
* `JIRA_ENCODED_TOKEN`: It's the needed token to make requests to the JIRA api. To create it, go to: `Your profile > Manage your account > Security > Create and manage API tokens > Create API token`
* `URI_JIRA`: It's URI of Jira. Example: `mycompany.jira.com`

#### Environment variables:

To customize this action you have the following environment variables:

* `REVIEWERS`: The list of all maintainers to be added in the PR (separated by commas without spaces)

* `REGEXP_FOR_JIRA_CODE_ON_PR_TITLE`: The regular expression to obtain the Jira issue code from the pull request title.
In the example we have a code like: "**ABCD-1234** Feature to make something". The issue code is used to retrieve the priority of the issue from Jira and add it as a label in order to prioritize the code review.

* `LABELS_ON_PULL_REQUEST_OPENED`: List of labels that will be added to the PR when opened.


### Example

![Alt Text](https://thumbs.gfycat.com/ElaborateDearestHermitcrab-size_restricted.gif)


## Credits

Thanks to [Marc Cornellà](https://github.com/mcornella) to introduce me on Github Actions and show me this post https://blog.jessfraz.com/post/the-life-of-a-github-action/ of [Jess Frazelle](https://github.com/jessfraz) !
