# Sharedcloud-agent

Background agent used by `Sharedcloud-cli` and in charge of listening for jobs and sessions.

### Use

The following ENV vars need to be passed when creating the Docker container:

* `PAYLOAD_FILENAME`: Describes the filename of the generated file.


For example:
```
>>> docker build . -t sharedcloud-agent

>>> docker run --rm --name sharedcloud-agent -e PAYLOAD_FILENAME=data.json \
                                             -d sharedcloud-agent
```