# Contributing

Thank you for your interest in improving this reference. Contributions help keep the pattern accurate, portable, and easier to adopt.

## How to contribute

1. **Fork** the repository under your GitHub account.
2. Create a **topic branch** from the default branch (for example `feature/short-description` or `fix/issue-description`).
3. Make focused changes with clear commit messages that describe intent, not only file names.
4. Open a **pull request** against the upstream default branch. Reference related issues in the description when applicable.

Keep pull requests scoped: one logical change per PR is easier to review and bisect than a large mixed refactor.

## Code review

Maintainers review pull requests for:

- Correctness relative to OpenShift, ACM, and OpenShift GitOps behavior described in product documentation
- Consistency with existing directory layout, naming, and Kustomize patterns
- Security posture (for example avoiding committed secrets, minimizing privileged examples)
- Clarity of README and inline comments where behavior is non-obvious

Address review feedback with additional commits or, after discussion, amend as requested. Approval from a maintainer is required before merge.

## Reporting issues

Use GitHub **Issues** to report defects, documentation gaps, or compatibility problems with specific OpenShift / ACM versions. Include:

- Observed behavior and expected behavior
- Relevant OpenShift, ACM, and OpenShift GitOps versions
- Minimal steps to reproduce, including which manifests or scripts were applied
- Redacted logs or Argo CD application status snippets when helpful

Do not attach secrets, kubeconfigs, or private repository URLs in public issues.

## License

By contributing, you agree that your contributions are licensed under the same terms as the project. See [LICENSE](LICENSE).
