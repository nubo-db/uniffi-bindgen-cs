# uniffi-bindgen-cs - UniFFI C# bindings generator

> **This is a fork.** It is maintained by [nubo-db](https://github.com/nubo-db) for use by the
> Nubo Windows client, and tracks [uniffi-rs](https://github.com/mozilla/uniffi-rs) releases on
> the schedule Nubo needs. Upstream is
> [NordSecurity/uniffi-bindgen-cs](https://github.com/NordSecurity/uniffi-bindgen-cs), and all of
> the design and nearly all of the code is theirs and their contributors'.
>
> Issues are disabled here. If you are looking for the general-purpose generator, use upstream.
> Changes we author are offered upstream as pull requests as well as being carried here.
>
> Beyond the pull requests it carries from upstream, this fork's own changes are two fixes to
> the test environment, both offered upstream: the image installs the .NET runtime the test
> project targets, and `test_bindings.sh` runs from the solution directory so its `global.json`
> is read. Anything else we author will be offered upstream as a pull request as well as
> carried here, and listed in [CHANGELOG.md](CHANGELOG.md).
>
> One thing does differ and is not offered upstream. The CI workflow here is
> `.github/workflows/fork-cs.yml`, which builds the test-runner image from the `Dockerfile` in
> this repository rather than pulling upstream's published one, because a fork's token cannot
> read it. Upstream's `cs.yml` is left byte-identical and is disabled in this repository's
> Actions settings. For the same reason `./docker.sh` will not work here as written: build the
> image first with `docker build --tag uniffi-bindgen-cs-test-runner .` and run that tag.

Generate [UniFFI](https://github.com/mozilla/uniffi-rs) bindings for C#. `uniffi-bindgen-cs` lives
as a separate project from `uniffi-rs`, as per
[uniffi-rs #1355](https://github.com/mozilla/uniffi-rs/issues/1355).

# How to install

Minimum Rust version required to install `uniffi-bindgen-cs` is `1.88`.
Newer Rust versions should also work fine.

```bash
cargo install uniffi-bindgen-cs --git https://github.com/nubo-db/uniffi-bindgen-cs --tag v0.12.1+v0.32.0
```

# How to generate bindings

```bash
uniffi-bindgen-cs path/to/definitions.udl
```
Generates bindings file `path/to/definitions.cs`

# How to integrate bindings

To integrate the bindings into your projects, simply add the generated bindings file to your project.
There are a few requirements depending on your target framework version.

- .NET core `8.0` or higher
    ```xml
    <PropertyGroup>
        <TargetFramework>net8.0</TargetFramework>
        <AllowUnsafeBlocks>true</AllowUnsafeBlocks>
    </PropertyGroup>
    ```

- .NET framework `4.6.1`
    ```xml
    <PropertyGroup>
        <TargetFramework>net461</TargetFramework>
        <LangVersion>10.0</LangVersion>
        <AllowUnsafeBlocks>true</AllowUnsafeBlocks>
        <PackageReference Include="Microsoft.CSharp" Version="4.7.0" />
        <PackageReference Include="PolySharp" Version="1.15.0"/>
    </PropertyGroup>
    ```

# Known Limitations

### String/byte[]/lists size limit

Currently size of strings/byte[]/lists/dictionaries/sets is limited to `i32: 2^31`. Exceeding this limit will result in exceptions.

This does not apply to `[ByRef] bytes` / `&[u8]` arguments, which are passed to Rust as a pointer into
the pinned C# array rather than copied into a `RustBuffer`.

# Configuration options

It's possible to [configure some settings](docs/CONFIGURATION.md) by passing `--config`
argument to the generator.
```bash
uniffi-bindgen-cs path/to/definitions.udl --config path/to/uniffi.toml
```

# Versioning

`uniffi-bindgen-cs` is versioned separately from `uniffi-rs`. UniFFI follows the [SemVer rules from
the Cargo Book](https://doc.rust-lang.org/cargo/reference/resolver.html#semver-compatibility)
which states "Versions are considered compatible if their left-most non-zero
major/minor/patch component is the same". A breaking change is any modification to the C# bindings
that demands the consumer of the bindings to make corresponding changes to their code to ensure that
the bindings continue to function properly. `uniffi-bindgen-cs` is young, and it's unclear how stable
the generated bindings are going to be between versions. For this reason, major version is currently
0, and most changes are probably going to bump minor version.

To ensure consistent feature set across external binding generators, `uniffi-bindgen-cs` targets
a specific `uniffi-rs` version. A consumer using Go bindings (in `uniffi-bindgen-go`) and C#
bindings (in `uniffi-bindgen-cs`) expects the same features to be available across multiple bindings
generators. This means that the consumer should choose external binding generator versions such that
each generator targets the same `uniffi-rs` version.

To simplify this choice `uniffi-bindgen-cs` and `uniffi-bindgen-go` use tag naming convention
as follows: `vX.Y.Z+vA.B.C`, where `X.Y.Z` is the version of the generator itself, and `A.B.C` is
the version of uniffi-rs it is based on.

The table shows `uniffi-rs` version history for tags that were published before tag naming convention described above was introduced.

| uniffi-bindgen-cs version                 | uniffi-rs version                                |
|-------------------------------------------|--------------------------------------------------|
| v0.12.1                                   | v0.32.0                                          |
| v0.11.0                                   | v0.31.0                                          |
| v0.10.0                                   | v0.29.4                                          |
| v0.9.0                                    | v0.28.3                                          |
| v0.6.0                                    | v0.25.0                                          |
| v0.5.0                                    | v0.24.0                                          |
| ~~v0.3.0~~ (DONT USE, UNFINISHED)         | ~~3142151e v0.24.0?~~                            |
| v0.2.0                                    | v0.23.0                                          |
| v0.1.0                                    | v0.20.0                                          |

# Documentation

More documentation is available in [docs](docs) directory.

# Contributing

For contribution guidelines, read [CONTRIBUTING.md](CONTRIBUTING.md).
