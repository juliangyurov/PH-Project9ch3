## [Project 9: Grand Central Dispatch](https://www.hackingwithswift.com/read/9/overview)
Written by [Paul Hudson](https://www.hackingwithswift.com/about)  ![twitter16](https://github.com/juliangyurov/PH-Project6a/assets/13259596/445c8ea0-65c4-4dba-8e1f-3f2750f0ef51)
  [@twostraws](https://twitter.com/twostraws)


**Description:** Learn how to run complex tasks in the background with GCD.

- Setting up

- Why is locking the UI bad?

- GCD 101: async()

- Back to the main thread: DispatchQueue.main

- Easy GCD using performSelector(inBackground:)

- Wrap up

## [Review what you learned](https://www.hackingwithswift.com/review/hws/project-9-grand-central-dispatch)

**Challenge**

1. Modify project 1 so that loading the list of NSSL images from our bundle happens in the background. Make sure you call reloadData() on the table view once loading has finished!

2. Modify project 8 so that loading and parsing a level takes place in the background. Once you’re done, make sure you update the UI on the main thread!

3. Modify project 7 so that your filtering code takes place in the background. This filtering code was added in one of the challenges for the project, so hopefully you didn’t skip it!
