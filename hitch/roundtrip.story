Roundtripped YAML:
  based on: strictyaml
  description: |
    Loaded YAML can be modified and dumped out again with
    comments preserved using .as_yaml().
    
    Note that due to some bugs in the library (ruamel.yaml)
    underlying StrictYAML, the YAML loaded and dumped out
    may not always look the same (e.g. 
    implementation, the YAML loaded and dumped out may not
    always look exactly the same.
  scenario:
    - Code: |
        from strictyaml import Map, Str, Int, YAMLValidationError, load

        schema = Map({"a": Str(), "b": Int()})
    
    - Variable:
        name: commented_yaml
        value: |
          # Some comment
          
          a: â # value comment
          
          # Another comment
          b: 1

    - Returns True: |
        load(commented_yaml, schema).as_yaml() == commented_yaml


    - Code: |
        to_modify = load(commented_yaml, schema)

        to_modify['b'] = 2
    
    - Raises Exception:
        command: |
          to_modify['b'] = 'not an integer'
        exception: expected

    - Variable:
        name: modified_commented_yaml
        value: |
          # Some comment
          
          a: â # value comment
          
          # Another comment
          b: 2

    - Returns True: |
        to_modify.as_yaml() == modified_commented_yaml

    - Variable:
        name: with_integer
        value: |
          x: 1

    - Returns True: |
       load(with_integer, Map({"x": Int()})).as_yaml() == "x: 1\n"
