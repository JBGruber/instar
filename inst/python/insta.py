import csv
import os.path
import re
from datetime import datetime
from itertools import dropwhile, takewhile
from os import path
from random import randint
from time import sleep

import instaloader

instagram = instaloader.Instaloader(
    quiet=False,
    download_pictures=False,
    download_videos=False,
    download_comments=True,
    download_geotags=False,
    download_video_thumbnails=False,
    compress_json=False,
    save_metadata=True,
)


def get_post(SHORTCODE):
    post = instaloader.Post.from_shortcode(instagram.context, SHORTCODE)
    post_dict = {
        "accessibility_caption": post.accessibility_caption,
        "mediacount": post.mediacount,
        "sponsor_users": post.sponsor_users,
        "caption": post.caption,
        "mediaid": post.mediaid,
        "supported_graphql_types": post.supported_graphql_types(),
        "caption_hashtags": post.caption_hashtags,
        "is_videos": post.get_is_videos(),
        "tagged_users": post.tagged_users,
        "caption_mentions": post.caption_mentions,
        # 'likes': post.get_likes(),
        "owner_id": post.owner_id,
        "title": post.title,
        "comments": post.comments,
        # 'sidecar_nodes': post.get_sidecar_nodes(),
        # 'owner_profile': post.owner_profile,
        "typename": post.typename,
        "date": post.date,
        "is_pinned": post.is_pinned,
        "owner_username": post.owner_username,
        "url": post.url,
        "date_local": post.date_local,
        "is_sponsored": post.is_sponsored,
        "pcaption": post.pcaption,
        "video_duration": post.video_duration,
        "date_utc": post.date_utc,
        "is_video": post.is_video,
        "profile": post.profile,
        "video_url": post.video_url,
        # 'from_iphone_struct': post.from_iphone_struct(),
        "likes": post.likes,
        "shortcode": post.shortcode,
        "video_view_count": post.video_view_count,
        # 'from_mediaid': post.from_mediaid(),
        "location": post.location,
        # 'shortcode_to_mediaid': post.shortcode_to_mediaid()
        "viewer_has_liked": post.viewer_has_liked,
    }
    return post_dict


def insta_login_py(user=None, passwd=None, file=None, save=True, force_refresh=False):
    if os.path.isfile(file) and not force_refresh:
        instagram.load_session_from_file(username=user, filename=file)
        return True
    if not user or not passwd:
        return False
    instagram.login(user=user, passwd=passwd)
    if save:
        instagram.save_session_to_file(file)
    return True


def save_csv(save_path, results_posts):
    if not path.exists(save_path):
        with open(save_path, "w", newline="", encoding="utf-8") as csvfile:
            fieldnames = [*results_posts[0].keys()]
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
    if path.exists(save_path):
        with open(save_path, "a", newline="", encoding="utf-8") as csvfile:
            fieldnames = [*results_posts[0].keys()]
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            for dictrow in results_posts:
                writer.writerow(dictrow)


def insta_posts_py(
    query, scope, max_posts, scrape_comments, save_path="", since="", until=""
):
    """
    Run custom search

    Fetches data from Instagram via instaloader.
    """
    # this is useful to include in the results because researchers are
    # always thirsty for them hashtags
    hashtag = re.compile(r"#([^\s,.+=-]+)")
    mention = re.compile(r"@([a-zA-Z0-9_]+)")

    queries = query.split(",")

    if since != "" and until != "":
        since = since.split("-")
        until = until.split("-")

        for item in range(len(since)):
            since[item] = int(since[item])

        for item in range(len(until)):
            until[item] = int(until[item])

        since = datetime(since[0], since[1], since[2])
        until = datetime(until[0], until[1], until[2])

        # return queries
    posts = []

    # for each query, get items
    for query in queries:
        chunk_size = 0
        print("Retrieving posts ('%s')" % query)
        try:
            if scope == "hashtag":
                query = query.replace("#", "")
                hashtag_obj = instaloader.Hashtag.from_name(instagram.context, query)
                chunk = hashtag_obj.get_posts()
            elif scope == "username":
                query = query.replace("@", "")
                profile = instaloader.Profile.from_username(instagram.context, query)
                chunk = profile.get_posts()
            else:
                print("Invalid search scope for instagram scraper: %s" % repr(scope))
                return []

            # "chunk" is a generator so actually retrieve the posts next
            posts_processed = 0
            for post in chunk:

                chunk_size += 1
                print("Retrieving posts ('%s', %i posts)" % (query, chunk_size))
                if posts_processed >= max_posts:
                    break
                try:
                    posts.append(chunk.__next__())
                    posts_processed += 1
                except StopIteration:
                    break
        except instaloader.InstaloaderException as e:
            print("Error while retrieving posts for query '%s'" % query)

    # go through posts, and retrieve comments
    results = []
    posts_processed = 0
    comments_bit = " and comments" if scrape_comments == True else ""

    if since != "" and until != "":
        posts = takewhile(
            lambda p: p.date > until, dropwhile(lambda p: p.date > since, posts)
        )

    for post in posts:

        results_posts = []

        posts_processed += 1
        print("Retrieving metadata%s for post %i" % (comments_bit, posts_processed))

        thread_id = post.shortcode

        try:
            results_posts.append(
                {
                    "id": str(thread_id),
                    "thread_id": str(thread_id),
                    "parent_id": str(thread_id),
                    "body": post.caption if post.caption is not None else "",
                    "author": post.owner_username,
                    "timestamp": post.date_utc.timestamp(),
                    "type": "video" if post.is_video else "picture",
                    "url": post.video_url if post.is_video else post.url,
                    "thumbnail_url": post.url,
                    "hashtags": ",".join(post.caption_hashtags),
                    "usertags": ",".join(post.tagged_users),
                    "mentioned": ",".join(
                        mention.findall(post.caption) if post.caption else ""
                    ),
                    "num_likes": post.likes,
                    "num_comments": post.comments,
                    "level": "post",
                    "query": query,
                }
            )
        except (
            instaloader.QueryReturnedNotFoundException,
            instaloader.ConnectionException,
        ):
            pass

        if not scrape_comments == True:
            if save_path != "":
                save_csv(save_path, results_posts)
            results.append(results_posts)
            continue

        if posts_processed % 10 == 0:
            wait_time = randint(300, 500)
            print("Wating for " + str(wait_time) + " seconds.")
            sleep(wait_time)
        else:
            wait_time = randint(20, 30)
            print("Wating for " + str(wait_time) + " seconds.")
            sleep(wait_time)

        try:
            for comment in post.get_comments():
                answers = [answer for answer in comment.answers]

                try:
                    results_posts.append(
                        {
                            "id": str(comment.id),
                            "thread_id": str(thread_id),
                            "parent_id": str(thread_id),
                            "body": comment.text,
                            "author": comment.owner.username,
                            "timestamp": comment.created_at_utc.timestamp(),
                            "type": "comment",
                            "url": "",
                            "hashtags": ",".join(hashtag.findall(comment.text)),
                            "usertags": "",
                            "mentioned": ",".join(mention.findall(comment.text)),
                            "num_likes": (
                                comment.likes_count
                                if hasattr(comment, "likes_count")
                                else 0
                            ),
                            "num_comments": len(answers),
                            "level": "comment",
                            "query": query,
                        }
                    )
                except instaloader.QueryReturnedNotFoundException:
                    pass

                # instagram only has one reply depth level at the time of
                # writing, represented here
                for answer in answers:
                    try:
                        results_posts.append(
                            {
                                "id": str(answer.id),
                                "thread_id": str(thread_id),
                                "parent_id": str(comment.id),
                                "body": answer.text,
                                "author": answer.owner.username,
                                "timestamp": answer.created_at_utc.timestamp(),
                                "type": "comment",
                                "url": "",
                                "hashtags": ",".join(hashtag.findall(answer.text)),
                                "usertags": "",
                                "mentioned": ",".join(mention.findall(answer.text)),
                                "num_likes": (
                                    answer.likes_count
                                    if hasattr(answer, "likes_count")
                                    else 0
                                ),
                                "num_comments": 0,
                                "level": "answer",
                                "query": query,
                            }
                        )
                    except instaloader.QueryReturnedNotFoundException:
                        pass

        except (
            instaloader.QueryReturnedNotFoundException,
            instaloader.ConnectionException,
        ):
            # data not available...? this happens sometimes, not clear why
            pass

        if save_path != "":
            save_csv(save_path, results_posts)

        results.append(results_posts)

    return results


def get_followers(username):

    profile = instaloader.Profile.from_username(instagram.context, username)

    follower_list = []
    for follower in profile.get_followers():
        # print(follower.username)
        follower_list.append(follower.username)

    return follower_list


def get_similar_accounts(username):

    profile = instaloader.Profile.from_username(instagram.context, username)

    account_list = []
    for account in profile.get_similar_accounts():
        # print(account.username)
        account_list.append(account.username)

    return account_list
