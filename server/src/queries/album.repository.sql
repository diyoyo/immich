-- NOTE: This file is auto generated by ./sql-generator

-- AlbumRepository.getById
select
  "albums".*,
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          *
        from
          "shared_links"
        where
          "shared_links"."albumId" = "albums"."id"
      ) as agg
  ) as "sharedLinks"
from
  "albums"
where
  "albums"."id" = $1
  and "albums"."deletedAt" is null

-- AlbumRepository.getByAssetId
select
  "albums".*,
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers"
from
  "albums"
  left join "albums_assets_assets" as "album_assets" on "album_assets"."albumsId" = "albums"."id"
  left join "albums_shared_users_users" as "album_users" on "album_users"."albumsId" = "albums"."id"
where
  (
    (
      "albums"."ownerId" = $1
      and "album_assets"."assetsId" = $2
    )
    or (
      "album_users"."usersId" = $3
      and "album_assets"."assetsId" = $4
    )
  )
  and "albums"."deletedAt" is null
order by
  "albums"."createdAt" desc,
  "albums"."createdAt" desc

-- AlbumRepository.getMetadataForIds
select
  "albums"."id",
  min("assets"."fileCreatedAt") as "startDate",
  max("assets"."fileCreatedAt") as "endDate",
  count("assets"."id") as "assetCount"
from
  "albums"
  left join "albums_assets_assets" as "album_assets" on "album_assets"."albumsId" = "albums"."id"
  left join "assets" on "assets"."id" = "album_assets"."assetsId"
where
  "albums"."id" in ($1)
group by
  "albums"."id"

-- AlbumRepository.getOwned
select
  "albums".*,
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          *
        from
          "shared_links"
        where
          "shared_links"."albumId" = "albums"."id"
      ) as agg
  ) as "sharedLinks"
from
  "albums"
where
  "albums"."ownerId" = $1
  and "albums"."deletedAt" is null
order by
  "albums"."createdAt" desc

-- AlbumRepository.getShared
select distinct
  on ("albums"."createdAt") "albums".*,
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers",
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          *
        from
          "shared_links"
        where
          "shared_links"."albumId" = "albums"."id"
      ) as agg
  ) as "sharedLinks"
from
  "albums"
  left join "albums_shared_users_users" as "shared_albums" on "shared_albums"."albumsId" = "albums"."id"
  left join "shared_links" on "shared_links"."albumId" = "albums"."id"
where
  (
    "shared_albums"."usersId" = $1
    or "shared_links"."userId" = $2
    or (
      "albums"."ownerId" = $3
      and "shared_albums"."usersId" is not null
    )
  )
  and "albums"."deletedAt" is null
order by
  "albums"."createdAt" desc

-- AlbumRepository.getNotShared
select distinct
  on ("albums"."createdAt") "albums".*,
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          "album_users".*,
          (
            select
              to_json(obj)
            from
              (
                select
                  "id",
                  "email",
                  "createdAt",
                  "profileImagePath",
                  "isAdmin",
                  "shouldChangePassword",
                  "deletedAt",
                  "oauthId",
                  "updatedAt",
                  "storageLabel",
                  "name",
                  "quotaSizeInBytes",
                  "quotaUsageInBytes",
                  "status",
                  "profileChangedAt"
                from
                  "users"
                where
                  "users"."id" = "album_users"."usersId"
              ) as obj
          ) as "user"
        from
          "albums_shared_users_users" as "album_users"
        where
          "album_users"."albumsId" = "albums"."id"
      ) as agg
  ) as "albumUsers",
  (
    select
      to_json(obj)
    from
      (
        select
          "id",
          "email",
          "createdAt",
          "profileImagePath",
          "isAdmin",
          "shouldChangePassword",
          "deletedAt",
          "oauthId",
          "updatedAt",
          "storageLabel",
          "name",
          "quotaSizeInBytes",
          "quotaUsageInBytes",
          "status",
          "profileChangedAt"
        from
          "users"
        where
          "users"."id" = "albums"."ownerId"
      ) as obj
  ) as "owner",
  (
    select
      coalesce(json_agg(agg), '[]')
    from
      (
        select
          *
        from
          "shared_links"
        where
          "shared_links"."albumId" = "albums"."id"
      ) as agg
  ) as "sharedLinks"
from
  "albums"
  left join "albums_shared_users_users" as "shared_albums" on "shared_albums"."albumsId" = "albums"."id"
  left join "shared_links" on "shared_links"."albumId" = "albums"."id"
where
  "albums"."ownerId" = $1
  and "shared_albums"."usersId" is null
  and "shared_links"."userId" is null
  and "albums"."deletedAt" is null
order by
  "albums"."createdAt" desc

-- AlbumRepository.getAssetIds
select
  *
from
  "albums_assets_assets"
where
  "albums_assets_assets"."albumsId" = $1
  and "albums_assets_assets"."assetsId" in ($2)
