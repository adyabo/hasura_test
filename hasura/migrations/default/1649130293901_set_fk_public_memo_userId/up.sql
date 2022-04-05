alter table "public"."memo"
  add constraint "memo_userId_fkey"
  foreign key ("userId")
  references "public"."user"
  ("id") on update restrict on delete restrict;
