# MovieChat
MovieChat Test Project

# How to run

1. Setup Firebase account to use Cloud Firestore as database. Then use the generated "GoogleService-Info.plist" in the project;
2. Run `pod install` to install all necessary pods;
3. Build and run the project.

# Architeture used

Using MVP (Model View Presenter), for clearer separation of responsabilities and easier testing, the project consists in a three
screens app:

- Welcome screen: simple form to get user name;
- Movies list screen: a UITableView populated with movies from [movies.json](https://tender-mclean-00a2bd.netlify.com/mobile/movies.json), showing network use case;
- Movie chat screen: also a UITableView populated with comments stored in Cloud Firestore database:
  - In this simple project the current user's own comments are checked by the user's name;
  - The database model consists of:
    - movies collection:
      - The movie title is the document ID;
      - comments collection:
        - content: String;
        - insertTimestamp: Timestamp;
        - user object:
          - name: String.

# What could be done next

With more time and planning, some ideas could done:

- Full sign in flow with authentication;
- Movies list pagination and filter;
- Movie chat pagination and enhancementes like possibility to remove comments
and comment in other comment.
- Definitely a better design.