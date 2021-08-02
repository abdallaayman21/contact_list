# Contact List

Contact list is a flutter mobile application that has couple of features such as:

- **View contacts list based on date.**
- **Generate new random contacts on Pull-To-Refresh.**
- **Share contacts to other installed applications.**
- **View contacts date in two formats: 'Time Ago' & formatted date string.**

## Used Packages

These are the used packages in this project:

- [jiffy](https://pub.dev/packages/jiffy) to manage the 'Time Ago' feature.
- [faker](https://pub.dev/packages/faker) to help in generating random names, phones and dates.
- [shared_preferences](https://pub.dev/packages/shared_preferences) to store the user's toggle option of 'Time Ago' button.
- [share](https://pub.dev/packages/share) to allow the application to share contacts with other installed apps.
- [path_provider](https://pub.dev/packages/path_provider) to help in generating a temporary path to store the contact file ```vCard.vcf``` until it is shared.

## Application Demo

### View Contacts based on date:

![view-contacts-list](https://user-images.githubusercontent.com/60911017/127787784-c886122c-3f86-4004-a8da-959f51822673.gif)

---

### Toggle Button to change date view:

![toggle-button](https://user-images.githubusercontent.com/60911017/127788744-599c7cc5-53ab-4523-9068-ff312070f9fe.gif)

---

### Pull-To-Refresh to generate 5 random contacts:

![pull-to-refresh](https://user-images.githubusercontent.com/60911017/127789389-c4a57732-bae9-45ef-8663-5bb8059c88ab.gif)

### Share contact information to other installed applications:

![share-contact](https://user-images.githubusercontent.com/60911017/127789734-14d1644d-8162-4182-8642-d0f88686db70.gif)