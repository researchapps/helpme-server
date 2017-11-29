# Development

We need to build the image, bring it up, and make a self signed certificate [ref](https://github.com/msis/docker-compose-nginx-gogs)

```
docker build -t vanessa/gogs .
```

Set the password to what you want, you will need to input this later into the web interface


```
export POSTGRES_USER=gogs 
export POSTGRES_PASSWORD=gogs 
docker-compose up -d
```

Then create a self signed certificate

```
docker exec -it (gitserver) bash
cd /data/gogs/conf/
/app/gogs/gogs cert -ca=true -duration=8760h0m0s -host=0.0.0.0
exit
docker-compose restart
```

You can then go to 127.0.0.1 in your browser. It probably will tell you it's not secure and you need to add an exception, do that for now and enter the information about your database.

## Updating the Image
After you've started the image, if you select a sqlite3 database you can have data persist easily between updates (granted no changes to the database). I created a script [quick-build.sh](docker/quick-build.sh) that simply re-builds gogs, intended if you are working inside the image. If not, it's probably about the same time to rebuild the image externally.

## What do I want to build?

1. A user or organization creates a "issue-router," which is simply a board that will handle logic for directing issues to their respective knowledge bases.  The helpme command line tool is configured to send issues here.
 - each issue will have an environment and capture (asciinema)
 - each issue will be associated with a user (authenticated in some way based on the setup)
2. On the cluster (or other) resource, the config file for "helpme" will have a call to post an issue to the issue-router on behalf of the user. The user credentials (authorization) are handled with some custom authentication backend (e.g., LDAP), or a private account.
3. The upload process does the following:
 - Asks the user for various metadata
 - Records a capture and the environment
 - checks for environment variables (e.g., tags or topics) to send to the router.
4. Upon receiving a new issue, the router checks tags / topics and then sends a webhook to one or more knowledge repos that match the tags. If there are no matches, it is not hooked (and some message should show that knowledge isn't found / should be made). This means that upon config of the issue router, one or more tags should be assigned to other repositories. E.g.:

 
```
error --> stanford-error
error+sherlock --> sherlock-error
```

The specific way of tagging and matching is TBD. The general idea is that then the webhook sends the issue down a chain of knowledge repos, each of which assesses the new issue (content extracted, webhooks, etc) and then matches it against its own content. A response with a uri to the match is then sent back to the issue tracker for the user to find.

5. The user (on the command line) gets a link to the original issue-router, which will have a manifest / direction of where knowledge for the answer can be found. In the future, it could include a direct link to the content / answer and return this to the user.

## Plan of Action

1. First customize the interface so it is "HelpMe" branded
2. Figure out if gogs has an API. If so, [turn it on](https://github.com/gogits/go-gogs-client/wiki)
3. Create a command line tool (helpme container) that is able to collect a help request, record asciinema, and then submit to an API endpoint.
4. Figure out how to (programaticall? In the interface?) configure a webhook to trigger other repos, and then do something with the content.
5. Give proper credit to Gogs, contact to ask about logo on [website](https://gogs.io).
