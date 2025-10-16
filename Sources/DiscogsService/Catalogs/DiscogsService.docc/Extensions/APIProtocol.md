# ``APIProtocol``

## Topics

### Service endpoints

- ``APIProtocol/getService(_:)``
- ``APIProtocol/getService(headers:)``

### Authentication endpoints

- ``APIProtocol/getRequestToken(_:)``
- ``APIProtocol/getRequestToken(headers:)``
- ``APIProtocol/postAccessToken(_:)``
- ``APIProtocol/postAccessToken(headers:)``
- ``APIProtocol/getUserIdentity(_:)``
- ``APIProtocol/getUserIdentity(headers:)``

### Database endpoints

- ``APIProtocol/searchDatabase(_:)``
- ``APIProtocol/searchDatabase(query:headers:)``
- ``APIProtocol/getArtist(_:)``
- ``APIProtocol/getArtist(path:headers:)``
- ``APIProtocol/getArtistReleases(_:)``
- ``APIProtocol/getArtistReleases(path:query:headers:)``
- ``APIProtocol/getLabel(_:)``
- ``APIProtocol/getLabel(path:headers:)``
- ``APIProtocol/getLabelReleases(_:)``
- ``APIProtocol/getLabelReleases(path:query:headers:)``
- ``APIProtocol/getMaster(_:)``
- ``APIProtocol/getMaster(path:headers:)``
- ``APIProtocol/getMasterVersions(_:)``
- ``APIProtocol/getMasterVersions(path:query:headers:)``
- ``APIProtocol/getRelease(_:)``
- ``APIProtocol/getRelease(path:query:headers:)``
- ``APIProtocol/getReleaseRating(_:)``
- ``APIProtocol/getReleaseRating(path:headers:)``
- ``APIProtocol/getReleaseRatingByUser(_:)``
- ``APIProtocol/getReleaseRatingByUser(path:headers:)``
- ``APIProtocol/putReleaseRatingByUser(_:)``
- ``APIProtocol/putReleaseRatingByUser(path:query:headers:)``
- ``APIProtocol/deleteReleaseRatingByUser(_:)``
- ``APIProtocol/deleteReleaseRatingByUser(path:headers:)``
- ``APIProtocol/getReleaseStats(_:)``
- ``APIProtocol/getReleaseStats(path:headers:)``

### User Identity

- ``APIProtocol/getUserProfile(_:)``
- ``APIProtocol/getUserProfile(path:headers:)``
- ``APIProtocol/postUserProfile(_:)``
- ``APIProtocol/postUserProfile(path:query:headers:)``
- ``APIProtocol/getUserContributions(_:)``
- ``APIProtocol/getUserContributions(path:query:headers:)``
- ``APIProtocol/getUserSubmissions(_:)``
- ``APIProtocol/getUserSubmissions(path:headers:)``

### User Collection

- ``APIProtocol/getCollectionFolders(_:)``
- ``APIProtocol/getCollectionFolders(path:headers:)``
- ``APIProtocol/postCollectionFolders(_:)``
- ``APIProtocol/postCollectionFolders(path:query:headers:)``
- ``APIProtocol/getCollectionFolder(_:)``
- ``APIProtocol/getCollectionFolder(path:headers:)``
- ``APIProtocol/postCollectionFolder(_:)``
- ``APIProtocol/postCollectionFolder(path:query:headers:)``
- ``APIProtocol/deleteCollectionFolder(_:)``
- ``APIProtocol/deleteCollectionFolder(path:headers:)``
- ``APIProtocol/getCollectionItemsByRelease(_:)``
- ``APIProtocol/getCollectionItemsByRelease(path:headers:)``
- ``APIProtocol/getCollectionItemsByFolder(_:)``
- ``APIProtocol/getCollectionItemsByFolder(path:query:headers:)``
- ``APIProtocol/postReleaseToCollectionFolder(_:)``
- ``APIProtocol/postReleaseToCollectionFolder(path:headers:)``
- ``APIProtocol/postChangeRatingOfRelease(_:)``
- ``APIProtocol/postChangeRatingOfRelease(path:query:headers:body:)``
- ``APIProtocol/deleteInstanceFromCollectionFolder(_:)``
- ``APIProtocol/deleteInstanceFromCollectionFolder(path:headers:)``
- ``APIProtocol/getCustomFields(_:)``
- ``APIProtocol/getCustomFields(path:headers:)``
- ``APIProtocol/editFieldsInstance(_:)``
- ``APIProtocol/editFieldsInstance(path:query:headers:)``
- ``APIProtocol/getCollectionValue(_:)``
- ``APIProtocol/getCollectionValue(path:headers:)``