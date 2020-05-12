# ColonelKurtzEx (CKEX)

`ColonelKurtzEx` facilitates working with the block content editor [Colonel Kurtz](https://github.com/vigetlabs/colonel-kurtz) in [Phoenix](https://www.phoenixframework.org/) applications. The main faculties `ColonelKurtzEx` provides are focused on **structured data**, **validation**, and **rendering**.

[Documentation](http://code.viget.com/colonel_kurtz_ex/) is available on GitHub and will be on HexDocs soon!

**Note on terminology**: For clarity and conciseness, this document may refer to the elixir library as **`CKEX`** and the javascript library as **`CKJS`**.

# Table of Contents
1. [Overview](#overview)
2. [Installation](#installation)
3. [Getting Set Up](#getting-set-up)
4. [FAQs](#faqs)
5. [Development](#development)
6. [Contributing](#contributing)
7. [Authors](#authors)
8. [License](#license)

## Overview

<details>
  <summary>
    <strong>Colonel Kurtz (CKJS)</strong>
  </summary>

  Colonel Kurtz is a block content editor implemented in JS.

  It is recommended that you have a reasonable understanding of `CKJS` and how to use it before diving into `CKEX`. Specifically, how the data is structured and how to extend its functionality with new block types. Head over to [the repo](https://github.com/vigetlabs/colonel-kurtz) for more information.

  Here's a brief summary of the basics to better orient you to some concepts relevant to `CKEX`:

  1. `CKJS` produces a (potentially deeply) nested tree of `blocks` in JSON format.
  2. A `block` has the following fields: `type`, `content`, and `blocks` (the latter represents any nested child blocks).
  3. When you define a `CKJS` block type, you implement it using a React Component which affords you great flexibility when it comes to the UI you present to users of your application.
</details>

<details>
  <summary>
    <strong>Structured Data</strong>
  </summary>

  Anyone familiar with Elixir and the surrounding community is likely to already understand the benefits of structured data. This isn't an essay on the subject but suffice to say that we believe in using named structs and predictable data wherever possible. One of the main motivations of `ColonelKurtzEx` is to convert `CKJS` JSON into named  structs.
</details>

<details>
  <summary>
    <strong>Validation</strong>
  </summary>

  Data integrity is crucial to building robust software and validation is important for helping users create valid data through providing helpful error messages. `ColonelKurtzEx` gives developers the ability to validate `CKJS` JSON data by leveraging [Ecto Changesets](https://hexdocs.pm/ecto/Ecto.Changeset.html#content) which should be familiar to many Elixir developers. If you've done anything with databases or validation you've likely used `Ecto` and will be familiar with how to implement validation rules for CK data using `CKEX`.
</details>

<details>
  <summary>
    <strong>Rendering</strong>
  </summary>

  `ColonelKurtzEx` provides a `BlockTypeView` macro that can be used in [Phoenix Views](https://hexdocs.pm/phoenix/Phoenix.View.html#content). A block type view, aside from being a normal Phoenix View (used to handle presentation of data), controls whether a block can render by specifying an implementation for `renderable?/1`. The default is `true`, but modules that `use` the macro may override this method to enable more fine-grained control over whether a block should be rendered based on its current data.

  For example, you might need to model a block that requires exactly 3 images to be defined in its data. If a greater or lesser number is specified, the block type view can disable rendering (e.g. to prevent invalid layouts from happening). However, you should try to implement these rules in your block type validation to prevent invalid data from reaching the database in the first place.
</details>

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed by adding `colonel_kurtz_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:colonel_kurtz_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc) and published on [HexDocs](https://hexdocs.pm). Once published, the docs can be found at [https://hexdocs.pm/colonel_kurtz_ex](https://hexdocs.pm/colonel_kurtz_ex).

## Getting Set Up

To get set up with `ColonelKurtzEx`, you'll need to install and configure [Colonel Kurtz](https://github.com/vigetlabs/colonel-kurtz). Since the two libraries go hand in hand, you'll often jump back and forth between the two. For example, when you add a new block type to `CKJS`, you'll need to add the corresponding modules for `CKEX` (a `BlockType`, `BlockTypeView`, and template). In the future `CKEX` will provide generators to expedite the process of common tasks such as adding a new block type.

**Note**: The following sections are expandable (and are collapsed by default).

<details>
  <summary>
    <strong>1. Add Folders for BlockTypes and BlockTypeViews</strong>
  </summary>

  After adding the library to your dependencies, you'll want to define a few modules in the scope of your application. One for your custom `BlockType` definitions, and one for your `BlockTypeView`s.

  **Note:** *it is important that each of these concepts live inside a dedicated module namespace in your application so that the library can look up specific block type and view modules at runtime.*

<details>
  <summary>
    See an example
  </summary>

  For example, assuming a standard phoenix project structure:

  1. Create a new subfolder inside `lib/your_app_web/views/`, using whatever name you'd like that corresponds with the module you'll be defining views inside (e.g. `lib/your_app_web/views/blocks/` folder and `YourAppWeb.Blocks` module.).

  2. Create a new subfolder inside `lib/your_app/`. Again, the name doesn't matter so long as you configure `ColonelKurtzEx` correctly (more information in the following section). For example, you might create a folder named `lib/your_app/block_types/` and to contain the `YourApp.BlockTypes` namespace.
</details>

  ---
</details>

<details>
  <summary>
    <strong>
      2. Configure <code>ColonelKurtzEx</code>
    </strong>
  </summary>

  Add the following to your `config/config.exs` to allow `CKEX` to locate your custom `BlockType` and `BlockTypeView` modules:

  ```elixir
  config :colonel_kurtz_ex, ColonelKurtz,
    block_views: YourAppWeb.Blocks,
    block_types: YourApp.BlockTypes
  ```

  ---
</details>

<details>
  <summary>
    <strong>
      3. Add a CK field to one of your app's schemas</code>
    </strong>
  </summary>

  1. First, amend the schema to add a new field that will hold your `CKJS` data:

      ```elixir
      defmodule YourApp.Post do
        use Ecto.Schema

        # 1. alias the custom ecto type
        alias ColonelKurtzEx.EctoBlocks

        # 2. import the validation helper
        import ColonelKurtzEx.Validation, only: [validate_blocks: 2]

        schema "posts" do
          field :title, :string
          # 3. add a field of this type, named whatever you like
          field :content, EctoBlocks, default: []
        end

        def changeset(post, params \\ %{}) do
          post
          # 4. make sure you cast the new field in your changeset
          |> cast(params, [:title, :content])
          # 5. call `validate_blocks` passing the name of your field
          |> validate_blocks(:content)
        end
      end
      ```

      **Note:** `validate_blocks/2` can take an atom or a list of atoms if you have more than one set of blocks fields to validate.

  2. Then create the migration to add the field to your database

      ```bash
      mix ecto.gen.migration add_content_to_posts
      ```

  3. `EctoBlocks` expects the underlying field to be a `:map` which is implemented as a `jsonb` column in Postgres.

      ```elixir
      # priv/repo/migrations/<timestamp>_add_content_to_posts.exs

      defmodule YourApp.Repo.Migrations.AddContentToPost do
        use Ecto.Migration

        def change do
          alter table("posts") do
            add :content, :map
          end
        end
      end
      ```

  4. Run your migration

      ```bash
      mix ecto.migrate
      ```
  ---
</details>

<details>
  <summary>
    <strong>
      4. Teach your Phoenix Views how to render blocks
    </strong>
  </summary>

  1. Use `ColonelKurtz.Renderer.render_blocks/1` to render block content somewhere in a template.

      <details>
        <summary>
          More information
        </summary>

        You may import this method as needed in the views that will render blocks. Or, as a convenience, you may import this function automatically in all of your phoenix views by adding it to the `your_app_web.ex` definition for `view` (or `view_helpers` if you want it to be available for live views as well, example below).
      </details>

  2. In addition, to render the block editor in your forms, you'll want to pull in `ColonelKurtz.FormHelpers` too. The example below shows how to do this for all Phoenix Views in your application.

      <details>
        <summary>
          See an example
        </summary>

        ```elixir
        # lib/your_app_web.ex

          # ...

          defp view_helpers do
            quote do
              use Phoenix.HTML

              import Phoenix.LiveView.Helpers
              import BlogDemoWeb.LiveHelpers

              # 1. import `render_blocks/1` so that it is available for all views
              import ColonelKurtz.Renderer, only: [render_blocks: 1]

              # 2. import the form helpers to make `block_editor/2` available in your form templates
              import ColonelKurtz.FormHelpers

              import Phoenix.View

              import BlogDemoWeb.ErrorHelpers
              import BlogDemoWeb.Gettext

              alias BlogDemoWeb.Router.Helpers, as: Routes
            end
          end
          # ...
        ```
      </details>

  3. Render your blocks inside your view's show template:

      ```elixir
      # lib/your_app_web/templates/post/show.html.eex

      # ...

      <%= render_blocks @post.content %>

      # ...

      ```

  4. Render the block editor field inside your view's form:

      ```elixir
      # lib/your_app_web/templates/post/form.html.eex

      # ...

      <%= label f, :content %>
      <%= error_tag f, :content %>
      <%= block_editor f, :content %>

      # ...
      ```

  ---
</details>

<details>
  <summary>
    <strong>
      5. Add your custom BlockTypes
    </strong>
  </summary>

  **Note**: As of this writing, there remains a lot of work to do in order to provide a default set of useful block types, some of which are already provided by `CKJS`, along with generators to aide in the creation of new block types.

  1. **Create your BlockType module**: Continuing from the example scenario outlined above, create a new block type at `lib/your_app/block_types/image.ex` where `image` is just an example of a descriptive name of the block you're modeling.

      ```elixir
      # lib/your_app/block_types/image.ex

      defmodule YourApp.BlockTypes.ImageBlock do
        # 1. use the BlockType macro, and specify the type string that matches the data returned by your CKJS block type
        use ColonelKurtz.BlockType, type: "image"

        # 2. use the `defattributes` macro to specify the schema for your block's content
        defattributes(
          src: :string,
          width: :integer,
          height: :integer
        )

        # 3. optional, but encouraged - define your validation rules for the block's content
        def validate_content(_content, changeset) do
          changeset
          |> validate_required([:src, :width, :height])
          # ... any other custom validation rules you need ...
        end

        # 4. optional, as necessary - define validation rules for the block itself
        def validate(_block, changeset) do
          changeset
          # e.g. this block must have at least 1 child block
          |> validate_length(:blocks, min: 1)
        end
      end
      ```

  2. **Create your BlockView**: create a new block view at `lib/your_app_web/blocks/image_view.ex`.

      **Note:** make sure you've configured `ColonelKurtzEx` with the location of your `block_views` and `block_types`. See "**Configure `ColonelKurtzEx`**" above.

      ```elixir
      # lib/your_app_web/blocks/image_view.ex

      defmodule YourAppWeb.Blocks.ImageView do
        use YourAppWeb, :view
        use ColonelKurtz.BlockTypeView

        # optionally implement `renderable?/1`
        def renderable?(%ImageBlock{content: %{src: ""}} = block), do: false
        def renderable?(_block), do: true
      end
      ```
  ---
</details>

## FAQs

<details>
  <summary>
    <strong>
      How can I inspect the block data or errors in a nice format?
    </strong>
  </summary>

  Take a look at the functions provided in `ColonelKurtz.FormHelpers`, specifically `blocks_json/3` and `block_errors_json/3`. Both of these methods accept a third argument which is a list of options to pass to `Jason.Encoder` (hint: try `pretty: true`).

  ---
</details>

<details>
  <summary>
    <strong>
      How does <code>ColonelKurtzEx</code> look up my custom block type and view modules?
    </strong>
  </summary>

  You configure the `:block_views` and `:block_types` options for `CKEX` in your `config.exs` by providing the modules in your app that will contain your custom block types and views. When `CKEX` marshalls blocks JSON, it parses data into lists of maps using `Jason` and then looks up a block type based on the block's `type` field.

  It does so by calling `Module.concat` with the module you specified for `:block_types` and `Macro.camelize(type) <> "Block"` (e.g. `"image"` => `YourApp.BlockTypes.ImageBlock`).

  Similarly, to lookup your view modules `CKEX` calls `Module.concat` with the module you specified for `:block_views` and `Macro.camelize(type) <> "View"` (e.g. `"image"` => `YourAppWeb.Blocks.ImageView`).

  ---
</details>

<details>
  <summary>
    <strong>
      My block type schema changed, how can I migrate my existing block data?
    </strong>
  </summary>

  Congratulations, you've discovered an unsolved Hard Problem™.

  We're currently working on a proposal for library changes that might better facilitate data migrations on CK block JSON.

  In the meantime, it is recommended to leverage your RDBMS's capabilities for querying and modifying JSON. Our best advice for now is: As much as you can, try to avoid the need to migrate CK JSON data.

  ---
</details>

## Development

### Code Quality

To help maintain high code quality this project uses [dialyxir](https://github.com/jeremyjh/dialyxir) and [credo](https://github.com/rrrene/credo) for static code analysis, [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html) for testing and [ExCoveralls](https://github.com/parroty/excoveralls) for test coverage.

#### Typespecs

    mix dialyzer

#### Code Style
    mix credo --strict

#### Tests
    mix test

## Contributing

1. [Fork](http://github.com/vigetlabs/colonel_kurtz_ex/fork) the library
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

- Solomon Hawk (@solomonhawk)
- Dylan Lederle-Ensign (@dlederle)

## License

ColonelKurtzEx is released under the MIT License. See the LICENSE file for further details.
