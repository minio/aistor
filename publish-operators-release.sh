#!/bin/bash

# Check if the RELEASE environment variable is set
if [ -z "${RELEASE_TAG}" ]; then
	echo "Error: RELEASE_TAG environment variable is not set. Please set it"
	exit 1
fi

branch_name="operators-release-${RELEASE_TAG}"

git checkout -b "$branch_name"
rm -rf resources/aistor-operator/
rm -rf resources/operators/
rm -rf resources/base/
rm -rf resources/docs/

operators=(
	"adminjob"
	"aihub"
	"keymanager"
	"object-store"
	"prompt"
	"warp"
)


for operator in "${operators[@]}"; do
	mkdir -p "resources/operators/base/${operator}"
	kustomize build "git@github.com/miniohq/aistor.git/resources/kubernetes/${operator}/?ref=${RELEASE_TAG}.operator&timeout=90s&submodules=false" -o "resources/operators/base/${operator}/"
	(cd "resources/operators/base/${operator}" && kustomize create --autodetect)
	mkdir -p "resources/operators/openshift/${operator}"
	kustomize build "git@github.com/miniohq/aistor.git/resources/openshift/${operator}/?ref=${RELEASE_TAG}.operator&timeout=90s&submodules=false" -o "resources/operators/openshift/${operator}/"
	(cd "resources/operators/openshift/${operator}" && kustomize create --autodetect)
done

# Copy API docs

cp -r ~/github.com/miniohq/aistor/operator/docs/api docs

# Package helm charts from a local directory for now

helm package ~/github.com/miniohq/aistor/helm/aistor -d helm-releases
helm package ~/github.com/miniohq/aistor/helm/object-store -d helm-releases
helm repo index --merge index.yaml --url https://aistor.min.io .

git add -A
git commit -m "operators-release-${RELEASE_TAG}"
git push origin "$branch_name"
gh pr create --base master --head "$branch_name" --title "Operators release ${RELEASE_TAG}" --body "Operators release ${RELEASE_TAG}"
