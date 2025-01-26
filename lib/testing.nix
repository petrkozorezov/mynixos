{ ... }: {
  assertVal =
    expr: expected:
      if (expr == expected) then
        { status = "ok"; }
      else
        {
          status   = "failed";
          expected = expected;
          got      = expr;
        };
}
