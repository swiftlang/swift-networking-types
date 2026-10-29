# Contributing to Swift Networking Types

Contributions are welcome. Swift Networking Types holds the shared currency types for Swift networking and is maintained by the [Swift Networking Workgroup](https://www.swift.org/networking-workgroup/). It follows the [guidelines for contributing code](https://www.swift.org/contributing/#contributing-code) that apply across the Swift project, and everyone taking part is expected to follow the [Swift Code of Conduct](https://www.swift.org/code-of-conduct/).

You can help by:

- Reporting bugs
- Improving documentation
- Adding tests and benchmarks
- Reviewing pull requests and joining design discussions in the [Networking category](https://forums.swift.org/c/development/networking/129) on the Swift forums

## Legal

By submitting a pull request, you represent that you have the right to license your contribution to Apple and the community, and agree by submitting the patch that your contributions are licensed under the Apache License v2.0 with Runtime Library Exception (see `LICENSE.txt`).

## Reporting bugs and security issues

Report bugs in [GitHub Issues](https://github.com/swiftlang/swift-networking-types/issues). A good report includes:

- The version or commit of Swift Networking Types
- What you were trying to do
- The simplest steps that reproduce the problem. A pull request with a failing test is the best reproduction, but pasting the test into the issue is fine.
- Your Swift version (`swift --version`) and operating system

Please don't report security vulnerabilities in public issues or on the forums. Follow the [Swift project's security policy](https://github.com/swiftlang/.github/blob/main/SECURITY.md) to report them privately.

## What kind of change is this?

**Fixes, documentation, tests, and optimizations.** Open a pull request directly. Small changes that everyone agrees on are the quickest way to make progress.

**New types or new API.** Start a conversation before you write much code. Open an issue, or start a thread in the [Networking category](https://forums.swift.org/c/development/networking/129), that describes the problem you want to solve. New features start out as [experimental features](#experimental-features) and are stabilized later through the evolution process.

**Changes to a design the workgroup has already reviewed.** These need the workgroup's approval before they merge, even when the change is a bug fix. That includes a fix that lets the API express something it couldn't before, or one that changes behavior people can see. A bug in code that hasn't been released yet can be fixed freely. If you aren't sure which kind of change you have, ask on the pull request or the forums.

## Experimental features

New features start out experimental. An experimental feature sits behind an explicit opt-in, so nobody picks it up by accident. It can be added, changed, or removed at any time through normal code review, comes with no source compatibility guarantees, and isn't a commitment that it will ever ship.

When you add one:

- Keep it behind the opt-in. Stable API must not expose experimental types or depend on them.
- Say that it's experimental in its documentation.
- Test it like anything else. Every configuration we ship has to build and pass tests in CI, with experimental features both enabled and disabled.
- Plan for it to graduate or go away. Experimental is a staging area, not a destination. When a feature is ready to join the stable, supported API, it goes through the [Swift evolution process](https://github.com/swiftlang/swift-evolution/blob/main/process.md), as applied by the workgroup, starting with a pitch in [Evolution > Pitches](https://forums.swift.org/c/evolution/pitches/5). A feature with no clear path to that point should be removed.

## Making a change

Fork the repository, make your change on a branch, and open a pull request against `main`. The code owners listed in [`.github/CODEOWNERS`](.github/CODEOWNERS) review pull requests.

A good change is:

1. **Small and focused.** One task per pull request. We may ask you to split a larger change into steps.
2. **Tested.** Behavior changes come with tests, and a bug fix includes a test that fails without it. Tests use [Swift Testing](https://github.com/swiftlang/swift-testing).
3. **Documented.** Public API has DocC documentation comments, and the reasons behind non-obvious decisions are written down.
4. **Explained.** The pull request description says what changed and why, and links the issue or forums thread where it was discussed.

## Performance

These types sit underneath most networking code, so how they perform matters to everything built on top of them. A change shouldn't make things slower, allocate more, or increase code size unless the workgroup has agreed the trade-off is worth it.

The initial set of measurements that we care about are:

- **Allocations**
- **Instructions executed**
- **Code size**, which matters most for Embedded Swift and other size-constrained environments

These measurements may change over time.

If your change touches code on a hot path, adds a type that will be used on one, or changes how code is inlined or specialized, include before and after measurements in the pull request description and say how you took them. If a regression is the price of something worth having, say so and explain why.

Code size depends on inlining and specialization, so we measure representative test targets rather than individual functions. In some cases, this may rely on downstream adopters measuring in their targets, so expect some iteration. A change that turns out to cost more than it first appeared may be reverted.

The repository doesn't have a benchmark suite yet. The first benchmarks will cover the currency types.

## Code style and CI

Code is formatted with [swift-format](https://github.com/swiftlang/swift-format) using the configuration in [`.swift-format`](.swift-format). New source files need the license header from [`.license_header_template`](.license_header_template). The tools version in `Package.swift` sets the minimum Swift toolchain you need.

Before you push, build, test, format, and lint:

```sh
swift build
swift test
swift format --in-place --recursive Sources Tests
swift format lint --strict --recursive Sources Tests
```

Every pull request runs the build and tests on the supported platforms and Swift versions, plus the shared Swift project soundness checks, which cover formatting, license headers, documentation, and similar. Please fix what CI reports. For a first pull request, a maintainer may need to approve the CI run. To run the same workflows locally with [`act`](https://github.com/nektos/act), see [Running workflows locally](https://github.com/swiftlang/github-workflows?tab=readme-ov-file#running-workflows-locally).

## Questions and discussion

Design questions and general discussion belong in the [Networking category](https://forums.swift.org/c/development/networking/129) on the Swift forums. For quick questions, the workgroup has a channel on the [Swift Open Source Slack](https://swift-open-source.slack.com/archives/C0BJMU6842G). Decisions happen asynchronously on the forums and GitHub, so you can take part without attending a meeting. The workgroup's public meetings are announced on the forums.
