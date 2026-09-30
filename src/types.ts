export type Role = "admin" | "board";

export type PacketStatus =
  | "in_progress"
  | "ready_for_review"
  | "query_pending"
  | "approved"
  | "denied";

export type ItemStatus = "pending" | "complete" | "na";

export type VoteChoice = "yes" | "no" | "pause_for_query";

export type ProviderType = "surgeon" | "pa" | "anesthesia";

export type CredentialingType = "new" | "recred";

export interface Env {
  DB: D1Database;
  ASSETS: Fetcher;
  APP_NAME: string;
  SESSION_DAYS: string;
  SESSION_SECRET?: string;
}

export interface UserRow {
  id: string;
  username: string;
  display_name: string;
  role: Role;
  password_hash: string;
  password_salt: string;
  must_change_password: number;
  active: number;
}

export interface PublicUser {
  id: string;
  username: string;
  displayName: string;
  role: Role;
  mustChangePassword: boolean;
}

export interface PacketItemRow {
  id: string;
  packet_id: string;
  item_key: string;
  label: string;
  sort_order: number;
  status: ItemStatus;
  notes: string;
  updated_at: string;
}

export interface VoteRow {
  id: string;
  packet_id: string;
  voter_user_id: string;
  voter_name: string;
  vote: VoteChoice | null;
  concern: string;
  query_resolution: string;
  voted_at: string | null;
  resolution_at: string | null;
}

export interface PacketRow {
  id: string;
  provider_name: string;
  provider_type: ProviderType;
  specialty: string;
  credentialing_type: CredentialingType;
  privilege_blocks: string;
  status: PacketStatus;
  notes: string;
  created_by: string | null;
  created_at: string;
  updated_at: string;
  ready_at: string | null;
  closed_at: string | null;
}

export interface ChecklistDef {
  key: string;
  label: string;
}
