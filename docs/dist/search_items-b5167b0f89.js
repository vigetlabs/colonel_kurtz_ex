searchNodes=[{"doc":"The BlockType module defines a macro that is used to mix in the Block Type behavior. Block Types are embedded Ecto Schemas that conform to the Validatable protocol. A Block is of some type (e.g. &quot;Image Block&quot;) and have a well-defined schema for the attributes they require. That schema is specified as a dynamically generated nested module within the using module and is defined by a user call to the defattributes macro that specifies the schema for the Blocks&#39; Content. The Block Type schema embeds_one of the Content module.","ref":"ColonelKurtz.BlockType.html","title":"ColonelKurtz.BlockType","type":"module"},{"doc":"Extracts the Block&#39;s Content attributes from params, converting string keys to atoms. Will only contain the keys specified in the schema (Defined by using the defattributes/1 macro).","ref":"ColonelKurtz.BlockType.html#attributes_from_params/2","title":"ColonelKurtz.BlockType.attributes_from_params/2","type":"function"},{"doc":"","ref":"ColonelKurtz.BlockType.html#defattributes/1","title":"ColonelKurtz.BlockType.defattributes/1","type":"macro"},{"doc":"","ref":"ColonelKurtz.BlockType.html#lift_content_errors/1","title":"ColonelKurtz.BlockType.lift_content_errors/1","type":"function"},{"doc":"","ref":"ColonelKurtz.BlockType.html#t:block/0","title":"ColonelKurtz.BlockType.block/0","type":"type"},{"doc":"","ref":"ColonelKurtz.BlockType.html#t:block_struct/0","title":"ColonelKurtz.BlockType.block_struct/0","type":"type"},{"doc":"","ref":"ColonelKurtz.BlockType.html#t:changeset/0","title":"ColonelKurtz.BlockType.changeset/0","type":"type"},{"doc":"","ref":"ColonelKurtz.BlockTypeView.html","title":"ColonelKurtz.BlockTypeView","type":"module"},{"doc":"Provides methods for marshalling data into named BlockType structs.","ref":"ColonelKurtz.BlockTypes.html","title":"ColonelKurtz.BlockTypes","type":"module"},{"doc":"Convert a map with atom keys to a named block type struct.","ref":"ColonelKurtz.BlockTypes.html#from_map/1","title":"ColonelKurtz.BlockTypes.from_map/1","type":"function"},{"doc":"Converts serialized json into named block type structs.","ref":"ColonelKurtz.BlockTypes.html#from_string/1","title":"ColonelKurtz.BlockTypes.from_string/1","type":"function"},{"doc":"","ref":"ColonelKurtz.BlockTypes.html#t:block/0","title":"ColonelKurtz.BlockTypes.block/0","type":"type"},{"doc":"","ref":"ColonelKurtz.BlockTypes.html#t:block_struct/0","title":"ColonelKurtz.BlockTypes.block_struct/0","type":"type"},{"doc":"Implements a custom Ecto.Type (https://hexdocs.pm/ecto/Ecto.Type.html#content) that models a serializable list of blocks stored as JSON.","ref":"ColonelKurtz.EctoBlocks.html","title":"ColonelKurtz.EctoBlocks","type":"module"},{"doc":"Callback implementation for Ecto.Type.cast/1.","ref":"ColonelKurtz.EctoBlocks.html#cast/1","title":"ColonelKurtz.EctoBlocks.cast/1","type":"function"},{"doc":"Callback implementation for Ecto.Type.dump/1.","ref":"ColonelKurtz.EctoBlocks.html#dump/1","title":"ColonelKurtz.EctoBlocks.dump/1","type":"function"},{"doc":"Callback implementation for Ecto.Type.embed_as/1.","ref":"ColonelKurtz.EctoBlocks.html#embed_as/1","title":"ColonelKurtz.EctoBlocks.embed_as/1","type":"function"},{"doc":"Callback implementation for Ecto.Type.equal?/2.","ref":"ColonelKurtz.EctoBlocks.html#equal?/2","title":"ColonelKurtz.EctoBlocks.equal?/2","type":"function"},{"doc":"Callback implementation for Ecto.Type.load/1.","ref":"ColonelKurtz.EctoBlocks.html#load/1","title":"ColonelKurtz.EctoBlocks.load/1","type":"function"},{"doc":"Callback implementation for Ecto.Type.type/0.","ref":"ColonelKurtz.EctoBlocks.html#type/0","title":"ColonelKurtz.EctoBlocks.type/0","type":"function"},{"doc":"","ref":"ColonelKurtz.EctoBlocks.html#t:block/0","title":"ColonelKurtz.EctoBlocks.block/0","type":"type"},{"doc":"","ref":"ColonelKurtz.EctoBlocks.html#t:block_struct/0","title":"ColonelKurtz.EctoBlocks.block_struct/0","type":"type"},{"doc":"","ref":"ColonelKurtz.EctoBlocks.html#t:content_struct/0","title":"ColonelKurtz.EctoBlocks.content_struct/0","type":"type"},{"doc":"Ecto helpers such as format_error for formatting errors.","ref":"ColonelKurtz.EctoHelpers.html","title":"ColonelKurtz.EctoHelpers","type":"module"},{"doc":"","ref":"ColonelKurtz.EctoHelpers.html#format_error/2","title":"ColonelKurtz.EctoHelpers.format_error/2","type":"function"},{"doc":"Form helpers for phoenix.","ref":"ColonelKurtz.FormHelpers.html","title":"ColonelKurtz.FormHelpers","type":"module"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#block_editor/2","title":"ColonelKurtz.FormHelpers.block_editor/2","type":"function"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#block_editor/3","title":"ColonelKurtz.FormHelpers.block_editor/3","type":"function"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#block_errors_json/2","title":"ColonelKurtz.FormHelpers.block_errors_json/2","type":"function"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#block_errors_json/3","title":"ColonelKurtz.FormHelpers.block_errors_json/3","type":"function"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#blocks_json/2","title":"ColonelKurtz.FormHelpers.blocks_json/2","type":"function"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#blocks_json/3","title":"ColonelKurtz.FormHelpers.blocks_json/3","type":"function"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#blocks_json_from_blocks/3","title":"ColonelKurtz.FormHelpers.blocks_json_from_blocks/3","type":"function"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#t:block_error/0","title":"ColonelKurtz.FormHelpers.block_error/0","type":"type"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#t:block_with_errors/0","title":"ColonelKurtz.FormHelpers.block_with_errors/0","type":"type"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#t:form/0","title":"ColonelKurtz.FormHelpers.form/0","type":"type"},{"doc":"","ref":"ColonelKurtz.FormHelpers.html#t:json_opts/0","title":"ColonelKurtz.FormHelpers.json_opts/0","type":"type"},{"doc":"Provides a utility for rendering blocks. Requires the application to configure :block_views for ColonelKurtz.","ref":"ColonelKurtz.Renderer.html","title":"ColonelKurtz.Renderer","type":"module"},{"doc":"","ref":"ColonelKurtz.Renderer.html#render_blocks/1","title":"ColonelKurtz.Renderer.render_blocks/1","type":"function"},{"doc":"","ref":"ColonelKurtz.Renderer.html#t:block/0","title":"ColonelKurtz.Renderer.block/0","type":"type"},{"doc":"ColonolKurtz.Validation provides validate_blocks/2 and validate_blocks/3 which are used to validate block data.","ref":"ColonelKurtz.Validation.html","title":"ColonelKurtz.Validation","type":"module"},{"doc":"Given a changeset with an EctoBlocks field of the name specified as field, validates the blocks contained in changeset.changes.&lt;field&gt;. Returns %Ecto.Changeset{}.","ref":"ColonelKurtz.Validation.html#validate_blocks/2","title":"ColonelKurtz.Validation.validate_blocks/2","type":"function"},{"doc":"","ref":"ColonelKurtz.Validation.html#validate_blocks/3","title":"ColonelKurtz.Validation.validate_blocks/3","type":"function"},{"doc":"","ref":"ColonelKurtz.Validation.html#t:changeset/0","title":"ColonelKurtz.Validation.changeset/0","type":"type"},{"doc":"","ref":"ColonelKurtz.Validation.html#t:changeset_list/0","title":"ColonelKurtz.Validation.changeset_list/0","type":"type"},{"doc":"ColonelKurtzEx ColonelKurtzEx facilitates working with the block content editor Colonel Kurtz in Phoenix applications.","ref":"readme.html","title":"ColonelKurtzEx","type":"extras"},{"doc":"If available in Hex, the package can be installed by adding colonel_kurtz_ex to your list of dependencies in mix.exs: def deps do [ {:colonel_kurtz_ex, &quot;~&gt; 0.1.0&quot;} ] end Documentation can be generated with ExDoc and published on HexDocs. Once published, the docs can be found at https://hexdocs.pm/colonel_kurtz_ex.","ref":"readme.html#installation","title":"ColonelKurtzEx - Installation","type":"extras"},{"doc":"Code Quality To support high code quality this project uses dialyxir and credo for static code analysis and ExUnit for testing. Typespecs mix dialyzer Code Style mix credo --strict Tests mix test","ref":"readme.html#development","title":"ColonelKurtzEx - Development","type":"extras"},{"doc":"Fork the library Create your feature branch (git checkout -b my-new-feature) Commit your changes (git commit -am &#39;Add some feature&#39;) Push to the branch (git push origin my-new-feature) Create new Pull Request","ref":"readme.html#contributing","title":"ColonelKurtzEx - Contributing","type":"extras"},{"doc":"Solomon Hawk (@solomonhawk) Dylan Lederle-Ensign (@dlederle)","ref":"readme.html#authors","title":"ColonelKurtzEx - Authors","type":"extras"},{"doc":"ColonelKurtzEx is released under the MIT License. See the LICENSE file for further details.","ref":"readme.html#license","title":"ColonelKurtzEx - License","type":"extras"}]