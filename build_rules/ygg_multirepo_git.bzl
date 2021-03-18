load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
    
def ygg_git_deps(package_overrides, repos, default_branch):
    """
    Get all git repos that you plan to manage with ygg

    Ygg will modify an environment variable to toggle which branch you are using
    and keep all repos being modified together in sync using a commonly named feature
    branch. Only locally pulled repos will be put on the same feature branch. All others
    will use the default branch

    repos: list of repos to pull
    ```
    repos = [
        {
            "name": str,
            "repo_name": str, 
            "remote": https://uri
        }
    ]

    NOTE: You must have a bazel file with the yggdrasil environment variables in your workspace
    yggdrasil will automatically create this for you, but you can also manually create this file 
    if desired
    """
    for repo in repos: 
        repo_name = repo['repo_name']
        branch = package_overrides.get(repo_name, default=default_branch)

        if branch == "local": 
            print("Using local version of package {}".format(repo_name, branch))
            path = "../{}/".format(repo['repo_name'])
            native.local_repository(
                name = repo['name'],
                path = path
            )
        else:
            print("Generating Git repo for {} using branch {}".format(repo_name, branch))
            git_repository(
                name=repo['name'], 
                remote=repo['remote'],
                branch=branch
            )