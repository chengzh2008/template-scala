#!/usr/bin/env bash
set -e

indent() {
    sed 's/^/    /'
}

PROJNAME_DEFAULT="$(basename "$(pwd)")"
if [ "$PROJNAME_DEFAULT" = "template-scala" ]; then
    PROJNAME_DEFAULT="my-project"
fi
read -r -p "Project name [$PROJNAME_DEFAULT]: " PROJNAME
PROJNAME=${PROJNAME:-$PROJNAME_DEFAULT}

ORGNAME_DEFAULT="myapp"
read -r -p "Organization name [$ORGNAME_DEFAULT]: " ORGNAME

PKGNAME_DEFAULT="hello"
read -r -p "Package name [$PKGNAME_DEFAULT]: " PKGNAME

AUTHNAME_DEFAULT=$(git config --default "Firstname Lastname" --get user.name)
read -r -p "Author name [$AUTHNAME_DEFAULT]: " AUTHNAME
AUTHNAME=${AUTHNAME:-$AUTHNAME_DEFAULT}

EMAIL_DEFAULT=$(git config --default "user@email.com" --get user.email)
read -r -p "Author email [$EMAIL_DEFAULT]: " EMAIL
EMAIL=${EMAIL:-$EMAIL_DEFAULT}

echo "Running template-haskell Haskell project generator wizard"

echo "Substituting placeholder variables..."
(
    set -x
    git ls-files | xargs -I _ sed -i '' \
        -e "s#PROJNAME#$PROJNAME#g" \
        -e "s#ORGNAME#$ORGNAME#g" \
        -e "s#PKGNAME#$PKGNAME#g" \
        -e "s#AUTHNAME#$AUTHNAME#g" \
        -e "s#EMAIL#$EMAIL#g" _
) 2>&1 | indent

echo "Renaming files..."
(
    set -x
    mv "src/main/scala/ORGNAME/PKGNAME" "src/main/scala/ORGNAME/$PKGNAME"
    mv "src/main/scala/ORGNAME" "src/main/scala/$ORGNAME"
    mv "src/test/scala/ORGNAME/PKGNAME" "src/test/scala/ORGNAME/$PKGNAME"
    mv "src/test/scala/ORGNAME" "src/test/scala/$ORGNAME"
) 2>&1 | indent

echo "Cleaning up..."
(
    set -x
    rm wizard.sh
) 2>&1 | indent

read -e -p 'Reinitialize git history? [Y/n]? ' REINIT

if [[ "$REINIT" != [Nn]* ]]; then
    echo "Reinitializing git..."
    (
        set -x
        rm -rf .git
        git init -b main
        git config user.name "$AUTHNAME"
        git config user.email "$EMAIL"
        git add --all
        git commit -m "Initial commit"
    ) 2>&1 | indent
fi

echo "All set!"
